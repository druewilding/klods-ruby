require "spec_helper"

RSpec.describe "tabs + tab_panel" do
  include Klods::Builders

  it "renders tablist and panels" do
    node = tabs([
      tab_panel({label: "One"}, "Content 1"),
      tab_panel({label: "Two"}, "Content 2")
    ])
    html = node.to_s
    expect(html).to include('role="tablist"')
    expect(html).to include('role="tab"')
    expect(html).to include('role="tabpanel"')
    expect(html).to include("One")
    expect(html).to include("Content 1")
    expect(html).to include("Content 2")
  end

  it "marks the first tab as active" do
    html = tabs([tab_panel({label: "A"}, "a"), tab_panel({label: "B"}, "b")]).to_s
    expect(html).to include('aria-selected="true"')
    expect(html).to include('aria-selected="false"')
    expect(html).to include("klods-tabs__tab--active")
  end

  it "hides non-active panels" do
    html = tabs([tab_panel({label: "A"}, "a"), tab_panel({label: "B"}, "b")]).to_s
    expect(html).to include(" hidden")
  end

  it "links each tab button to its panel via aria-controls / aria-labelledby" do
    html = tabs([tab_panel({label: "X"}, "x")]).to_s
    tab_id = html.match(/id="([^"]*klods-tabs-tab[^"]*)"/)&.captures&.first
    panel_id = html.match(/id="([^"]*klods-tabs-panel[^"]*)"/)&.captures&.first
    expect(tab_id).not_to be_nil
    expect(html).to include(%(aria-controls="#{panel_id}"))
    expect(html).to include(%(aria-labelledby="#{tab_id}"))
  end

  it "renders the outer container with klods-tabs class" do
    expect(tabs([tab_panel("Tab")]).to_s).to include('class="klods-tabs"')
  end
end
