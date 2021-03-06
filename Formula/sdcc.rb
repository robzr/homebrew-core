class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/4.0.0/sdcc-src-4.0.0.tar.bz2"
  sha256 "489180806fc20a3911ba4cf5ccaf1875b68910d7aed3f401bbd0695b0bef4e10"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", :public_domain, "Zlib"]
  revision 1
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  livecheck do
    url :stable
    regex(%r{url=.*?/sdcc-src[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "e002b79aa971132f16eca044273a2048fca8c162a4231b69f7d90086315e3d76"
    sha256 big_sur:       "5f6504340cb02b7de8cd7562e5b91533c9ff090e620f1e458a4843ebe6460ad3"
    sha256 catalina:      "876e548b2a8c31c2d45d753b59e528c82101d193398d8c158270849fe9703ece"
    sha256 mojave:        "214547215aa0b7598ecfd80cd291bbc64bd8b2d95c867fca9653e5d0aef042d6"
    sha256 high_sierra:   "1f2423cb4c4f66c34b8a68f9c7a967c4256ca438646260dbf50e7f4c0b5f8f59"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "gputils"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "texinfo" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
    rm Dir["#{bin}/*.el"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/sdcc", "-mz80", "#{testpath}/test.c"
    assert_predicate testpath/"test.ihx", :exist?
  end
end
