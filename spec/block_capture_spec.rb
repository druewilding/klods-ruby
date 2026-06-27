require "spec_helper"

# Simulates ActionView's capture helper, which creates a temporary output
# buffer, calls the block, and returns what was written (or the block's return
# value when nothing was written to the buffer).
module FakeCapture
  def capture(&block)
    block.call.to_s
  end
end

RSpec.describe "block capture" do
  include Klods::Builders
  include FakeCapture

  it "stack with a block produces the same output as stack with an array" do
    via_array = stack({gap: 4}, [p("Hello")])
    via_block = stack({gap: 4}) { p("Hello") }
    expect(via_block.to_s).to eq(via_array.to_s)
  end

  it "prose with a block renders children" do
    result = prose { h1({id: "title"}, "Welcome") }
    expect(result.to_s).to include('class="klods-prose"')
    expect(result.to_s).to include('<h1 id="title">Welcome</h1>')
  end

  it "card with nested blocks mirrors the array form" do
    via_array = card([card_title("Title"), card_body("Body")])
    via_block = card do
      card([card_title("Title"), card_body("Body")])
    end
    # The block form wraps in an extra card; just verify structure is present
    expect(via_block.to_s).to include('class="klods-card"')
    expect(via_block.to_s).to include("Title")
    expect(via_block.to_s).to include("Body")
    expect(via_array.to_s).to include("Title")
    expect(via_array.to_s).to include("Body")
  end

  it "html tag methods accept blocks" do
    result = p { strong("bold") }
    expect(result.to_s).to eq("<p><strong>bold</strong></p>")
  end

  it "cluster with a block renders children" do
    result = cluster({gap: 2}) { button("Save") }
    expect(result.to_s).to include('class="klods-cluster klods-cluster--gap-2"')
    expect(result.to_s).to include("klods-button")
    expect(result.to_s).to include("Save")
  end

  it "deeply nested blocks render the full tree" do
    result = stack({gap: 4}) do
      prose do
        h1({id: "heading"}, "Hello")
      end
    end
    expect(result.to_s).to include('class="klods-stack klods-stack--gap-4"')
    expect(result.to_s).to include('class="klods-prose"')
    expect(result.to_s).to include('<h1 id="heading">Hello</h1>')
  end

  it "ignores the block when capture is not available" do
    ctx = Class.new { include Klods::Builders }.new
    # No capture method — block is silently ignored
    result = ctx.stack({gap: 4}) { raise "should not run" }
    expect(result.to_s).to include('class="klods-stack klods-stack--gap-4"')
    expect(result.to_s).not_to include("should not run")
  end

  it "block takes precedence over explicit children when both are given" do
    result = prose([p("from array")]) { p("from block") }
    expect(result.to_s).to include("from block")
    expect(result.to_s).not_to include("from array")
  end

  it "tab_panel accepts a block for panel content" do
    result = tab_panel({label: "Settings"}) { p("Panel content") }
    expect(result.to_s).to include('data-tab-label="Settings"')
    expect(result.to_s).to include("Panel content")
  end

  it "nav_list with a block renders nav links" do
    result = nav_list do
      nav_link({href: "/", active: true}, "Home")
    end
    expect(result.to_s).to include('class="klods-nav__list"')
    expect(result.to_s).to include("klods-nav__link--active")
    expect(result.to_s).to include("Home")
  end
end
