class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://github.com/astral-sh/uv/archive/refs/tags/0.2.29.tar.gz"
  sha256 "b469b8e08ec736a2a91d12c9f49209ed7a73def7b937fc95a51e1fc66a5e6d1a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b63bfd4d2b06087e914b21ff2f60a8a6e2cc481b141d74d056886c0853538263"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81b24db7c6db1c52b8775366ce4547ef0add7d2e66357a4c669e6c2d9f29cd2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c5d26a43a80019308de72e76881c2289becc23914bcdd8fc89405edb914ac9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e2a7637855a7292a63a5b5420eef6cee8a5d3ece6f16537ae97d254fbf57fed"
    sha256 cellar: :any_skip_relocation, ventura:        "89578f4a15f39b0943a562b62bd70eccf21a8cae0fa257fd609996cc1eb46f43"
    sha256 cellar: :any_skip_relocation, monterey:       "5eed7f8a19625f618359bcf99b01c90565b80c22502f81c76a0d46ab8700319f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5561ecda6131c599889e8fd49f7188162f227a73fc80416cd76296834704e43"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test

  on_linux do
    # On macOS, bzip2-sys will use the bundled lib as it cannot find the system or brew lib.
    # We only ship bzip2.pc on Linux which bzip2-sys needs to find library.
    depends_on "bzip2"
  end

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
  end

  test do
    (testpath/"requirements.in").write <<~EOS
      requests
    EOS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}/uvx -q ruff@0.5.1 --version")
  end
end
