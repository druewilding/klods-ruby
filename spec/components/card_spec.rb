require "spec_helper"

RSpec.describe "card" do
  include Klods::Builders

  it "renders with no args" do
    expect(card.to_s).to eq('<div class="klods-card"></div>')
  end

  it "renders with children only" do
    expect(card("Hello").to_s).to eq('<div class="klods-card">Hello</div>')
  end

  it "renders with props + children" do
    expect(card({ elevated: true }, "Hi").to_s).to eq('<div class="klods-card klods-card--elevated">Hi</div>')
  end

  it "renders nested card builders" do
    node = card([card_title("Title"), card_body("Body")])
    expect(node.to_s).to eq(
      '<div class="klods-card">' \
      '<h3 class="klods-card__title">Title</h3>' \
      '<div class="klods-card__body">Body</div>' \
      "</div>"
    )
  end

  it "passes through arbitrary HTML attrs" do
    expect(card({ id: "my-card" }, "X").to_s).to include('id="my-card"')
  end

  it "renders card_footer" do
    expect(card_footer("Actions").to_s).to eq('<div class="klods-card__footer">Actions</div>')
  end
end
