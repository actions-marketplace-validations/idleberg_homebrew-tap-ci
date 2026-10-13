class HelloModified < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftpmirror.gnu.org/hello/hello-2.12.1.tar.gz"
  sha256 "8d99142afd92576f30b0cd7cb42a8dc6809998bc5d607d88761f512e26c7db20"
  license "GPL-3.0-or-later"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking", *std_configure_args(prefix: libexec)
    system "make", "install"
    bin.install_symlink libexec/"bin/hello" => "hello-modified"
  end

  test do
    assert_equal "Hello, world!\n", shell_output(bin/"hello-modified")
  end
end
