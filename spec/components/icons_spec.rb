require "spec_helper"

RSpec.describe "icons" do
  include Klods::Builders

  it "renders an icon span with inline SVG" do
    html = menu_icon.to_s
    expect(html).to include('class="klods-icon"')
    expect(html).to include("<svg")
    expect(html).to include('aria-hidden="true"')
  end

  it "renders a labeled icon with aria-label and role" do
    html = close_icon({ label: "Close dialog" }).to_s
    expect(html).to include('aria-label="Close dialog"')
    expect(html).to include('role="img"')
    expect(html).not_to include("aria-hidden")
  end

  it "renders small size" do
    expect(search_icon({ size: "small" }).to_s).to include('width="12"')
  end

  it "renders medium size by default" do
    expect(menu_icon.to_s).to include('width="20"')
  end

  it "renders large size" do
    expect(search_icon({ size: "large" }).to_s).to include('width="32"')
  end

  it "renders all 19 icon builders without error" do
    icons = [
      check_circle_icon, chev_down_icon, chev_left_icon, chev_right_icon,
      chev_up_icon, close_icon, copy_icon, danger_circle_icon, edit_icon,
      external_link_icon, eye_icon, eye_off_icon, info_circle_icon, menu_icon,
      plus_icon, search_icon, trash_icon, user_icon, warning_icon
    ]
    expect(icons.length).to eq(19)
    icons.each { |icon| expect(icon.to_s).to include("klods-icon") }
  end
end
