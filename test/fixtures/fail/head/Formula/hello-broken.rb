class HelloBroken < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftpmirror.gnu.org/hello/hello-2.12.3.tar.gz"
  sha256 "0d5f60154382fee10b114a1c34e785d8b1f492073ae2d3a6f7b147687b366aa0"
  license "GPL-3.0-or-later"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking", *std_configure_args(prefix: libexec)
    system "make", "install"
    bin.install_symlink libexec/"bin/hello" => "hello-broken"
  end

  test do
    assert_equal "Goodbye, world!\n", shell_output(bin/"hello-broken")
  end
end
