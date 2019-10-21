class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.59.0.tar.gz"
  sha256 "cb46adabf2e8e6c0b639dd1197234719d023823f29cfb6ad2005d1c960ce73c4"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9763a67a17ef5ae11c1a79ca97e5898c8d7999d74487432091b4f7251b3c6350" => :catalina
    sha256 "9fdca915591f7b84426a8c259979d955266dffd8fa89c705114c14ffd871443b" => :mojave
    sha256 "8fa4d09414c4d746d14d518b862bfd9adc9d6cc3de6e35588097c7d2678249d0" => :high_sierra
    sha256 "c32035708c6d60fce971eee46857f0b29b62abb4d24028be68878fa1cf6cc082" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children

    cd "src/github.com/gohugoio/hugo" do
      system "go", "build", "-o", bin/"hugo", "-tags", "extended", "main.go"

      # Build bash completion
      system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
      bash_completion.install "hugo.sh"

      # Build man pages; target dir man/ is hardcoded :(
      (Pathname.pwd/"man").mkpath
      system bin/"hugo", "gen", "man"
      man1.install Dir["man/*.1"]

      prefix.install_metafiles
    end
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
