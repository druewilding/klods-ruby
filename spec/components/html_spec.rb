require "spec_helper"

RSpec.describe "Html tag shortcuts" do
  include Klods::Builders

  it "renders p" do
    expect(p("hello").to_s).to eq("<p>hello</p>")
  end

  it "renders span" do
    expect(span("x").to_s).to eq("<span>x</span>")
  end

  it "renders ul with li children" do
    expect(ul([li("a"), li("b")]).to_s).to eq("<ul><li>a</li><li>b</li></ul>")
  end

  it "renders an anchor with href" do
    expect(a({href: "/path"}, "Link").to_s).to eq('<a href="/path">Link</a>')
  end

  it "renders h1 through h6" do
    (1..6).each do |n|
      expect(send(:"h#{n}", "Heading").to_s).to eq("<h#{n}>Heading</h#{n}>")
    end
  end

  it "renders img as void tag" do
    expect(img({src: "/logo.png", alt: "Logo"}).to_s).to eq('<img src="/logo.png" alt="Logo" />')
  end

  it "renders br as void tag" do
    expect(br.to_s).to eq("<br />")
  end

  it "renders strong and em" do
    expect(strong("bold").to_s).to eq("<strong>bold</strong>")
    expect(em("italic").to_s).to eq("<em>italic</em>")
  end

  it "renders pre and code" do
    expect(pre(code("snippet")).to_s).to eq("<pre><code>snippet</code></pre>")
  end

  it "renders div with class" do
    expect(div({class: "wrapper"}, "x").to_s).to eq('<div class="wrapper">x</div>')
  end
end
