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
    expect(modal({open: true}).to_s).to match(/ open[ >]/)
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

  it "modal_close self-wires close behavior via inline JS" do
    html = modal_close.to_s
    expect(html).to include("this.closest('dialog').close()")
  end

  it "modal_trigger renders as a button with klods-button class" do
    html = modal_trigger("Open").to_s
    expect(html).to start_with("<button")
    expect(html).to include("klods-button")
    expect(html).to include("Open")
  end

  it "modal_trigger includes inline JS to open next sibling dialog" do
    html = modal_trigger("Open").to_s
    expect(html).to include("this.nextElementSibling.showModal()")
  end

  it "modal_trigger has type=button" do
    expect(modal_trigger("Open").to_s).to include('type="button"')
  end

  it "modal_trigger supports variant prop" do
    html = modal_trigger({variant: "primary"}, "Open").to_s
    expect(html).to include("klods-button--primary")
  end

  it "modal_trigger renders children" do
    expect(modal_trigger("Show info").to_s).to include("Show info")
  end
end
