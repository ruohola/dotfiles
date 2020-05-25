#!/usr/bin/env python3

import collections
import os
import json
import unicodedata
import sys
import sqlite3
import re
import operator

VERSION = 1
MAX_RESULTS = 20

INDEX_FILE_NAME = os.path.expanduser(
    '~/Library/Caches/unicode_names.{0}.cache'.format(
        '.'.join(map(str, sys.version_info))
    )
)


STOPWORDS = ['of', 'with', 'the', 'a', 'an']


def tokenize(string):
    words = re.split(r'[\s_-]+', string.lower())
    non_stop_words = [w for w in words if w not in STOPWORDS]
    if non_stop_words:
        return non_stop_words
    return words


def ngrams(tokens, n):
    if len(tokens) < n:
        return
    for start in range(0, len(tokens) - n):
        lst = []
        for idx in range(n):
            lst.append(tokens[start + idx])
        yield lst


def build_index(db):
    db.execute('DROP TABLE IF EXISTS tokens')
    db.execute('CREATE TABLE tokens (token VARCHAR(32), codepoint INT)')
    db.execute('DROP TABLE IF EXISTS bigrams')
    db.execute('CREATE TABLE bigrams (token1 VARCHAR(32), token2 VARCHAR(32), codepoint INT)')
    db.execute('CREATE INDEX idx_bigrams_on_tokens ON bigrams (token1, token2)')
    db.execute('DROP TABLE IF EXISTS trigrams')
    db.execute('CREATE TABLE trigrams (token1 VARCHAR(32), token2 VARCHAR(32), token3 VARCHAR(32), codepoint INT)')
    db.execute('CREATE INDEX idx_trigrams_on_tokens ON trigrams (token1, token2, token3)')
    db.execute('DROP TABLE IF EXISTS original_names')
    db.execute('CREATE TABLE original_names (codepoint INT PRIMARY KEY, name VARCHAR(128))')
    db.execute('CREATE INDEX idx_original_names_on_name ON original_names (name)')
    db.execute('PRAGMA journal_mode = WAL')
    num_codepoints = 0
    for codepoint in range(32, 0x2FA1D):
        with db:
            char = chr(codepoint)
            try:
                name = unicodedata.name(char)
            except ValueError:
                continue
            num_codepoints += 1
            words = tokenize(name)
            for word in sorted(words):
                db.execute('INSERT INTO tokens(token, codepoint) VALUES(?, ?)', (word, codepoint))
            for bigram in ngrams(words, 2):
                db.execute('INSERT INTO bigrams(token1, token2, codepoint) VALUES(?, ?, ?)', (bigram[0], bigram[1], codepoint))
            for trigram in ngrams(words, 3):
                db.execute(
                    'INSERT INTO trigrams(token1, token2, token3, codepoint) VALUES(?, ?, ?, ?)',
                    (trigram[0], trigram[1], trigram[2], codepoint)
                )
            db.execute('INSERT INTO original_names(codepoint, name) VALUES (?, ?)',
                       (codepoint, name.lower()))
    db.execute(
        'CREATE TABLE IF NOT EXISTS build_meta ('
        'build_version INT PRIMARY KEY,'
        'unidata_version STRING,'
        'distinct_tokens BIGINT,'
        'distinct_bigrams BIGINT,'
        'distinct_trigrams BIGINT,'
        'codepoints BIGINT)'
    )
    with db:
        cursor = db.cursor()
        cursor.execute('SELECT COUNT(DISTINCT token) FROM tokens')
        distinct_tokens = cursor.fetchall()[0][0]
        cursor.execute('SELECT token1, token2, COUNT(*) FROM bigrams GROUP BY 1, 2')
        distinct_bigrams = 0
        for row in cursor:
            distinct_bigrams += 1
        cursor.execute('SELECT token1, token2, token3, COUNT(*) FROM trigrams GROUP BY 1, 2, 3')
        distinct_trigrams = 0
        for row in cursor:
            distinct_trigrams += 1
        db.execute(
            'INSERT INTO build_meta(build_version, unidata_version, distinct_tokens, distinct_bigrams, codepoints)'
            'VALUES(?, ?, ?, ?, ?)',
            (VERSION, unicodedata.unidata_version, distinct_tokens, distinct_bigrams, num_codepoints)
        )
    db.execute('PRAGMA wal_checkpoint(TRUNCATE)')
    return db


def open_or_create_db():
    db = sqlite3.connect(INDEX_FILE_NAME)
    try:
        cursor = db.cursor()
        cursor.execute('SELECT build_version, unidata_version FROM build_meta ORDER BY build_version DESC LIMIT 1')
        for row in cursor:
            if row[0] != VERSION:
                raise ValueError('Too old!')
            if row[1] != unicodedata.unidata_version:
                raise ValueError('Unidata too old')
        return db
    except Exception:
        pass
    db.close()
    try:
        os.unlink(INDEX_FILE_NAME)
    except Exception:
        pass
    db = sqlite3.connect(INDEX_FILE_NAME)
    build_index(db)
    return db


def main():
    query = ' '.join(sys.argv[1:])
    db = open_or_create_db()
    cursor = db.cursor()
    cursor.execute('SELECT * FROM build_meta ORDER BY build_version DESC LIMIT 1')
    for row in cursor:
        _, _, distinct_tokens, distinct_bigrams, distinct_trigrams, distinct_codepoints = row
        break
    matches = collections.Counter()
    tokens = tokenize(query)

    def score_codepoints(ngram):
        codepoint_matches = []
        matching_codepoints = 0
        for row in cursor:
            codepoint_matches.append(row[0])
            matching_codepoints += 1
        for row in codepoint_matches:
            matches[row] += ngram / matching_codepoints

    for word in tokens:
        cursor.execute('SELECT codepoint FROM tokens WHERE token=?', (word,))
        score_codepoints(1)
    for token1, token2 in ngrams(tokens, 2):
        cursor.execute('SELECT codepoint FROM bigrams WHERE token1=? AND token2=?', (token1, token2))
        score_codepoints(2)
    for token1, token2, token3 in ngrams(tokens, 3):
        cursor.execute('SELECT codepoint FROM trigrams WHERE token1=? AND token2=? AND token3=?', (token1, token2, token3))
        score_codepoints(3)
    cursor.execute('SELECT codepoint FROM original_names WHERE name=?', (query.lower(),))
    for row in cursor:
        matches[row[0]] += 10
    results = []
    for codepoint, score in sorted(matches.items(), key=operator.itemgetter(1), reverse=True):
        char = chr(codepoint)
        name = unicodedata.name(char)
        subtitle = 'U+{0} {1}'.format(hex(codepoint)[2:].upper(), name)
        results.append({
            'title': char,
            'subtitle': subtitle,
            'autocomplete': name,
            'type': 'default',
            'arg': char,
            'extra': {
                'score': score,
                'codepoint': codepoint,
            },
            'mods': {
                'shift': {
                    'arg': subtitle,
                },
                'cmd': {
                    'arg': subtitle,
                },
            },
            'text': {
                'copy': char,
                'largetype': '{0} {1}'.format(char, name)
            }
        })
        if len(results) >= MAX_RESULTS:
            break
    results.sort(key=lambda r: (-r['extra']['score'], len(r['subtitle']), r['extra']['codepoint']))
    print(json.dumps({'items': results}))


if __name__ == '__main__':
    main()
