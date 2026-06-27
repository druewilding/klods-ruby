require "spec_helper"

RSpec.describe "list + list_item" do
  include Klods::Builders

  it "renders a basic list" do
    node = list([list_item("One"), list_item("Two")])
    expect(node.to_s).to eq(
      '<ul class="klods-list">' \
      '<li class="klods-list__item">One</li>' \
      '<li class="klods-list__item">Two</li>' \
      "</ul>"
    )
  end

  it "renders list with flush modifier" do
    expect(list({ flush: true }).to_s).to include("klods-list--flush")
  end

  it "renders list_item with href as a link row" do
    node = list_item({ href: "/page" }, "Go")
    expect(node.to_s).to eq(
      '<li class="klods-list__item klods-list__item--link">' \
      '<a href="/page" class="klods-list__link">Go</a>' \
      "</li>"
    )
  end

  it "renders list_item with lead slot" do
    node = list_item({ lead: badge("!") }, "Content")
    html = node.to_s
    expect(html).to include("klods-list__lead")
    expect(html).to include("klods-list__content")
  end

  it "renders list_item with trail slot" do
    node = list_item({ trail: badge("→") }, "Content")
    html = node.to_s
    expect(html).to include("klods-list__content")
    expect(html).to include("klods-list__trail")
  end

  it "renders list_item with lead, content, and trail" do
    node = list_item({ lead: badge("!"), trail: badge("→") }, "Middle")
    html = node.to_s
    expect(html).to include("klods-list__lead")
    expect(html).to include("klods-list__content")
    expect(html).to include("klods-list__trail")
  end

  it "renders a linked list_item with lead slot" do
    node = list_item({ href: "/x", lead: badge("!") }, "Link")
    html = node.to_s
    expect(html).to include("klods-list__item--link")
    expect(html).to include("klods-list__lead")
    expect(html).to include("klods-list__link")
  end
end
