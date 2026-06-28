require "spec_helper"

RSpec.describe "layout builders" do
  include Klods::Builders

  it "renders page" do
    expect(page.to_s).to include('class="klods-page"')
  end

  it "renders page with sidebar modifier" do
    expect(page({sidebar: true}).to_s).to include("klods-page--with-sidebar")
  end

  it "renders page with trailing sidebar" do
    expect(page({sidebar: true, sidebar_position: "trailing"}).to_s).to include("klods-page--sidebar-trailing")
  end

  it "renders sticky_header modifier" do
    expect(page({sticky_header: true}).to_s).to include("klods-page--sticky-header")
  end

  it "renders header as a header element" do
    expect(header("nav").to_s).to start_with("<header")
    expect(header.to_s).to include("klods-header")
  end

  it "renders sidebar as aside" do
    expect(sidebar.to_s).to start_with("<aside")
    expect(sidebar.to_s).to include("klods-sidebar")
  end

  it "renders content as main" do
    expect(content.to_s).to start_with("<main")
    expect(content({narrow: true}).to_s).to include("klods-content--narrow")
  end

  it "renders footer" do
    expect(footer.to_s).to start_with("<footer")
  end

  it "renders section" do
    expect(section.to_s).to start_with("<section")
  end

  it "renders stack with gap modifier" do
    expect(stack({gap: 4}).to_s).to include("klods-stack--gap-4")
  end

  it "renders stack with narrow modifier" do
    expect(stack({narrow: true}).to_s).to include("klods-stack--narrow")
  end

  it "renders cluster with gap modifier" do
    expect(cluster({gap: 2}).to_s).to include("klods-cluster--gap-2")
  end

  it "renders row with inline modifier" do
    expect(row({inline: true}).to_s).to include("klods-row--inline")
  end

  it "renders grid with cols modifier" do
    expect(grid({cols: 3}).to_s).to include("klods-grid--cols-3")
  end

  it "renders grid with fit modifier" do
    expect(grid({fit: true}).to_s).to include("klods-grid--fit")
  end

  it "renders center" do
    expect(center.to_s).to include("klods-center")
  end

  it "renders spread" do
    expect(spread.to_s).to include("klods-spread")
  end

  it "renders sidebar_toggle button" do
    html = sidebar_toggle.to_s
    expect(html).to include('class="klods-sidebar-toggle"')
    expect(html).to include('aria-label="Toggle sidebar"')
    expect(html).to include('type="button"')
  end

  it "renders push utility" do
    expect(push.to_s).to include("klods-push")
    expect(push.to_s).to start_with("<span")
  end

  it "renders fill utility" do
    expect(fill.to_s).to include("klods-fill")
  end
end
