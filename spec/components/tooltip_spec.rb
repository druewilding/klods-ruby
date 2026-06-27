require "spec_helper"

RSpec.describe "tooltip" do
  include Klods::Builders

  it "renders tooltip wrapper with tip content" do
    node = tooltip({tip: "More info"}, span("hover me"))
    html = node.to_s
    expect(html).to include("klods-tooltip")
    expect(html).to include('role="tooltip"')
    expect(html).to include("More info")
    expect(html).to include("hover me")
  end

  it "applies position modifier to the tip span" do
    node = tooltip({tip: "Below", position: "below"}, span("*"))
    expect(node.to_s).to include("klods-tooltip__tip--below")
  end

  it "defaults to above position" do
    node = tooltip({tip: "Hi"}, span("x"))
    expect(node.to_s).to include("klods-tooltip__tip--above")
  end

  it "links wrapper to tip via aria-describedby" do
    node = tooltip({tip: "Info"}, span("?"))
    html = node.to_s
    tip_id = html.match(/id="(klods-tip-[^"]+)"/)&.captures&.first
    expect(tip_id).not_to be_nil
    expect(html).to include(%(aria-describedby="#{tip_id}"))
  end

  it "generates unique ids across multiple tooltips" do
    t1 = tooltip({tip: "A"}, span("1"))
    t2 = tooltip({tip: "B"}, span("2"))
    id1 = t1.to_s.match(/id="(klods-tip-[^"]+)"/)&.captures&.first
    id2 = t2.to_s.match(/id="(klods-tip-[^"]+)"/)&.captures&.first
    expect(id1).not_to eq(id2)
  end

  it "wires mouseenter and mouseleave to show and hide the tip" do
    html = tooltip({tip: "Info"}, span("?")).to_s
    expect(html).to include("onmouseenter=")
    expect(html).to include("onmouseleave=")
    expect(html).to include("data-open")
    expect(html).to include("querySelector('[role=tooltip]')")
  end

  it "wires focusin and focusout for keyboard accessibility" do
    html = tooltip({tip: "Info"}, span("?")).to_s
    expect(html).to include("onfocusin=")
    expect(html).to include("onfocusout=")
  end

  it "hides with a delay on mouseleave" do
    html = tooltip({tip: "Info"}, span("?")).to_s
    expect(html).to include("setTimeout")
  end
end
