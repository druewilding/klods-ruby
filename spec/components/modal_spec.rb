require "spec_helper"

RSpec.describe "modal" do
  include Klods::Builders

  it "renders a dialog element" do
    expect(modal.to_s).to start_with("<dialog")
    expect(modal.to_s).to include("klods-modal")
  end

  it "renders with children" do
    node = modal([modal_title("Hello"), modal_body("World")])
    html = node.to_s
    expect(html).to include("klods-modal__title")
    expect(html).to include("klods-modal__body")
  end

  it "adds open attr when open: true" do
    expect(modal({ open: true }).to_s).to match(/ open[ >]/)
  end

  it "does not add open attr by default" do
    expect(modal.to_s).not_to include(" open")
  end

  it "renders modal_panel" do
    expect(modal_panel("x").to_s).to include("klods-modal__panel")
  end

  it "renders modal_header" do
    expect(modal_header("x").to_s).to include("klods-modal__header")
  end

  it "renders modal_title as h2" do
    expect(modal_title("Hi").to_s).to start_with("<h2")
  end

  it "renders modal_actions" do
    expect(modal_actions.to_s).to include("klods-modal__actions")
  end

  it "renders modal_close button with aria-label" do
    html = modal_close.to_s
    expect(html).to include('aria-label="Close"')
    expect(html).to include("klods-modal__close")
    expect(html).to include('type="button"')
  end
end
