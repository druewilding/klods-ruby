require "spec_helper"

RSpec.describe "status" do
  include Klods::Builders

  it "renders with children only" do
    expect(status("Online").to_s).to eq('<span class="klods-status">Online</span>')
  end

  it "renders a variant modifier" do
    expect(status({variant: "success"}, "Online").to_s).to eq('<span class="klods-status klods-status--success">Online</span>')
  end

  it "does not add a modifier class for the default variant" do
    expect(status({variant: "default"}, "Offline").to_s).to eq('<span class="klods-status">Offline</span>')
  end

  it "renders the pulse modifier" do
    expect(status({variant: "danger", pulse: true}, "Recording").to_s)
      .to eq('<span class="klods-status klods-status--danger klods-status--pulse">Recording</span>')
  end

  it "leaves out pulse when false" do
    expect(status({pulse: false}, "Idle").to_s).to eq('<span class="klods-status">Idle</span>')
  end

  it "passes other attributes through, matching klods-js" do
    expect(status({role: "status"}, "Your turn").to_s).to eq('<span role="status" class="klods-status">Your turn</span>')
  end
end
