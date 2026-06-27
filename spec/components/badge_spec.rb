require "spec_helper"

RSpec.describe "badge" do
  include Klods::Builders

  it "renders with no args" do
    expect(badge.to_s).to eq('<span class="klods-badge"></span>')
  end

  it "renders with children only" do
    expect(badge("New").to_s).to eq('<span class="klods-badge">New</span>')
  end

  it "renders a variant modifier" do
    expect(badge({ variant: "success" }, "Done").to_s).to eq('<span class="klods-badge klods-badge--success">Done</span>')
  end

  it "does not add modifier class for default variant" do
    expect(badge({ variant: "default" }, "X").to_s).not_to include("klods-badge--default")
  end

  it "renders danger variant" do
    expect(badge({ variant: "danger" }, "!").to_s).to include("klods-badge--danger")
  end
end
