#!/bin/sh

# Output the path to nvm's current default node installation.

if [ -n "$NVM_DIR" ]; then
    nvm_dir="$NVM_DIR"
else
    nvm_dir="${HOME}/.nvm"
fi

node_version="$( (< "$nvm_dir/alias/default" || < ~/.nvmrc) 2> /dev/null)"
while [ -s "${nvm_dir}/alias/${node_version}" ] && [ ! -z "$node_version" ]; do
    node_version="$(<"${nvm_dir}/alias/${node_version}")"
done

node_dir="$(find "${nvm_dir}/versions/node" -maxdepth 1 -name "v${node_version#v}*" | sort -rV | head -n 1)"

printf '%s/bin/node' "$node_dir"
