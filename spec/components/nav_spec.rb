require "spec_helper"

RSpec.describe "Nav" do
  include Klods::Builders

  describe "#nav_link" do
    it "renders an anchor wrapped in li with base class" do
      result = nav_link({href: "/home"}, "Home")
      expect(result.to_s).to include("klods-nav__link")
      expect(result.to_s).to include('href="/home"')
      expect(result.to_s).to include(">Home<")
      expect(result.to_s).to start_with("<li>")
    end

    it "applies --active modifier" do
      result = nav_link({href: "/home", active: true}, "Home")
      expect(result.to_s).to include("klods-nav__link--active")
    end

    it "does not pass active as an HTML attribute" do
      result = nav_link({href: "/", active: true}, "Home")
      expect(result.to_s).not_to include('active="')
    end
  end
end
