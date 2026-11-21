require "spec_helper"

RSpec.describe "segmented" do
  include Klods::Builders

  def option(value, extra = "")
    %(<label class="klods-segmented__option"><input type="radio" class="klods-segmented__input" name="view" value="#{value}"#{extra} />#{value}</label>)
  end

  it "renders a radio group with an option for each string" do
    expect(segmented({name: "view", options: ["Day", "Week"]}).to_s)
      .to eq(%(<div role="radiogroup" class="klods-segmented">#{option("Day")}#{option("Week")}</div>))
  end

  it "checks the option matching value" do
    expect(segmented({name: "view", options: ["Day", "Week"], value: "Week"}).to_s)
      .to eq(%(<div role="radiogroup" class="klods-segmented">#{option("Day")}#{option("Week", " checked")}</div>))
  end

  it "names the group with label" do
    expect(segmented({name: "view", options: ["Day"], label: "View"}).to_s)
      .to eq(%(<div role="radiogroup" aria-label="View" class="klods-segmented">#{option("Day")}</div>))
  end

  it "takes options with a separate value, and disabled options" do
    html = segmented({
      name: "theme",
      options: [{label: "Auto", value: "auto"}, {label: "Dark", value: "dark", disabled: true}],
      value: "auto"
    }).to_s
    expect(html).to include('value="auto" checked />Auto</label>')
    expect(html).to include('value="dark" disabled />Dark</label>')
  end

  it "disables every option" do
    html = segmented({name: "view", options: ["Day", "Week"], disabled: true}).to_s
    expect(html.scan("disabled").length).to eq(2)
  end

  it "passes other attributes and classes through to the group, matching klods-js" do
    expect(segmented({name: "view", options: [], "aria-labelledby": "view-label", class: "toolbar"}).to_s)
      .to eq('<div aria-labelledby="view-label" role="radiogroup" class="klods-segmented toolbar"></div>')
  end

  it "escapes option text" do
    expect(segmented({name: "x", options: ["<b>"]}).to_s).to include("&lt;b&gt;</label>")
  end
end
