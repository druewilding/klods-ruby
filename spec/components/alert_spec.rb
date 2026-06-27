require "spec_helper"

RSpec.describe "alert" do
  include Klods::Builders

  it "adds role=alert by default" do
    expect(alert("Warning!").to_s).to include('role="alert"')
  end

  it "renders with no args" do
    expect(alert.to_s).to include("klods-alert")
  end

  it "renders a variant modifier" do
    expect(alert({ variant: "info" }, "FYI").to_s).to include("klods-alert--info")
  end

  it "does not add modifier class for default variant" do
    expect(alert({ variant: "default" }, "ok").to_s).not_to include("klods-alert--default")
  end

  it "allows role override" do
    expect(alert({ role: "status" }, "ok").to_s).to include('role="status"')
  end

  it "renders all variant classes" do
    %w[info success warning danger].each do |v|
      expect(alert({ variant: v }).to_s).to include("klods-alert--#{v}")
    end
  end
end
