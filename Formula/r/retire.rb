require "language/node"

class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-5.0.0.tgz"
  sha256 "1489f86f9f0de387257c8250930be3ced3e2aa5e9f1dceabd4a924bf9ed9bf96"
  license "Apache-2.0"
  head "https://github.com/RetireJS/retire.js.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "715d0edc7da02fb0d92a4b86ae11f6b23314b7fc7c7ca41a3c3e6e12bbd6c059"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retire --version")

    system "git", "clone", "https://github.com/appsecco/dvna.git"
    output = shell_output("#{bin}/retire --path dvna 2>&1", 13)
    assert_match(/jquery (\d+(?:\.\d+)+) has known vulnerabilities/, output)
  end
end
