# Homebrew's `tmux` formula, but for the 3.8 release candidate.
# Drop this and go back to `brew "tmux"` once 3.8 is in Homebrew.
class TmuxAT38 < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.8-rc3/tmux-3.8-rc3.tar.gz"
  sha256 "bc0875c70d0b9e47d9f9061b92fe5033769bf50ac3541affdd3a85621f7230d5"
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
