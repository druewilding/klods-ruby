require "spec_helper"

RSpec.describe "button" do
  include Klods::Builders

  it "defaults to type=button" do
    expect(button("Click").to_s).to include('type="button"')
  end

  it "renders with no args" do
    expect(button.to_s).to include("klods-button")
  end

  it "allows type override" do
    expect(button({type: "submit"}, "Go").to_s).to include('type="submit"')
  end

  it "renders primary variant" do
    expect(button({variant: "primary"}, "OK").to_s).to include("klods-button--primary")
  end

  it "renders danger variant" do
    expect(button({variant: "danger"}, "Delete").to_s).to include("klods-button--danger")
  end

  it "renders ghost variant" do
    expect(button({variant: "ghost"}, "Cancel").to_s).to include("klods-button--ghost")
  end

  it "does not add modifier for default variant" do
    expect(button({variant: "default"}, "OK").to_s).not_to include("klods-button--default")
  end

  it "renders button_group" do
    node = button_group([button("A"), button("B")])
    expect(node.to_s).to include("klods-button-group")
  end
end
