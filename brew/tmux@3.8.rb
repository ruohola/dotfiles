# Homebrew's `tmux` formula, but with `tmux@3.8.patch` applied.
class TmuxAT38 < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.8/tmux-3.8.tar.gz"
  sha256 "e79c699c7e949dccd0a4a125e17b8d1261e311b16979dbc8eb34542f3966d82e"
  license "ISC"

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "utf8proc"

  uses_from_macos "bison" => :build # for yacc

  on_macos do
    depends_on "jemalloc"
  end

  conflicts_with "tmux", because: "both install a `tmux` binary"

  # (Resolve the symlink from the local tap, see `Brewfile`.)
  patch File.read(File.join(File.dirname(File.realpath(__FILE__)), "tmux@3.8.patch"))

  def install
    args = %W[
      --enable-sixel
      --sysconfdir=#{etc}
      --enable-utf8proc
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "3.8", shell_output("#{bin}/tmux -V")
  end
end
