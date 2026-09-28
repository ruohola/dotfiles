# Homebrew's `tmux` formula, but for the 3.8 release candidate.
# Drop this and go back to `brew "tmux"` once 3.8 is in Homebrew.
class TmuxAT38 < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.8-rc2/tmux-3.8-rc2.tar.gz"
  sha256 "6a976a6ee712ab12562f4671d7de55a919bc1f0067c3703ed5871378700a2fee"
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
