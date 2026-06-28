require "spec_helper"

RSpec.describe "Toc" do
  include Klods::Builders

  describe "#toc_link" do
    it "renders an anchor with base class" do
      result = toc_link({href: "#intro"}, "Introduction")
      expect(result.to_s).to include("klods-toc__link")
      expect(result.to_s).to include('href="#intro"')
      expect(result.to_s).to include(">Introduction<")
    end

    it "applies --active modifier" do
      result = toc_link({href: "#intro", active: true}, "Introduction")
      expect(result.to_s).to include("klods-toc__link--active")
    end

    it "does not pass active as an HTML attribute" do
      result = toc_link({href: "#intro", active: true}, "Introduction")
      expect(result.to_s).not_to include('active="')
    end
  end

  describe "#toc" do
    it "renders a ul with base class" do
      result = toc(toc_item(toc_link({href: "#a"}, "A")))
      expect(result.to_s).to start_with('<ul class="klods-toc">')
    end

    it "applies --sub modifier" do
      result = toc({sub: true}, toc_item(toc_link({href: "#a"}, "A")))
      expect(result.to_s).to include("klods-toc--sub")
    end
  end
end
