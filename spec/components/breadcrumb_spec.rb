require "spec_helper"

RSpec.describe "breadcrumbs + crumb" do
  include Klods::Builders

  it "renders accessible breadcrumb nav" do
    node = breadcrumbs([
      crumb({href: "/"}, "Home"),
      crumb({href: "/products"}, "Products"),
      crumb("Widget")
    ])
    html = node.to_s
    expect(html).to include('aria-label="Breadcrumb"')
    expect(html).to include('class="klods-breadcrumb__list"')
    expect(html).to include('href="/"')
    expect(html).to include('href="/products"')
  end

  it "marks the last crumb with aria-current=page" do
    node = breadcrumbs([crumb({href: "/"}, "Home"), crumb("Now")])
    expect(node.to_s).to include('aria-current="page"')
  end

  it "does not link the last crumb" do
    node = breadcrumbs([crumb({href: "/"}, "Home"), crumb("Now")])
    html = node.to_s
    expect(html.scan("<a ").length).to eq(1)
  end

  it "accepts a custom aria-label" do
    node = breadcrumbs([crumb("Only")], {"aria-label" => "Navigation trail"})
    expect(node.to_s).to include('aria-label="Navigation trail"')
  end

  it "wraps crumbs in an ol inside nav" do
    node = breadcrumbs([crumb("Home")])
    html = node.to_s
    expect(html).to match(/<nav[^>]*>.*<ol[^>]*>/m)
  end
end
