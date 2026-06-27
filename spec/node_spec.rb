require "spec_helper"

RSpec.describe Klods::Node do
  include Klods::Builders

  it "renders a simple element" do
    expect(el("p", "hello").to_s).to eq("<p>hello</p>")
  end

  it "escapes text children" do
    expect(el("p", "<script>").to_s).to eq("<p>&lt;script&gt;</p>")
  end

  it "renders void tags self-closing" do
    expect(el("br").to_s).to eq("<br />")
    expect(el("input", {type: "text"}).to_s).to eq('<input type="text" />')
  end

  it "omits nil and false attrs" do
    expect(el("div", {class: nil, id: false, "data-x": "y"}).to_s).to eq('<div data-x="y"></div>')
  end

  it "renders boolean attrs without a value" do
    expect(el("input", {type: "checkbox", checked: true}).to_s).to eq('<input type="checkbox" checked />')
  end

  it "passes RawHtml through unescaped" do
    expect(el("div", Klods::Core.raw("<b>raw</b>")).to_s).to eq("<div><b>raw</b></div>")
  end

  it "flattens nested arrays of children" do
    expect(el("ul", [el("li", "a"), [el("li", "b")]]).to_s).to eq("<ul><li>a</li><li>b</li></ul>")
  end

  it "drops nil and false children" do
    expect(el("div", [nil, "hello", false]).to_s).to eq("<div>hello</div>")
  end

  it "ignores children on void tags" do
    node = Klods::Node.new("br", {}, ["oops"])
    expect(node.to_s).to eq("<br />")
  end
end
