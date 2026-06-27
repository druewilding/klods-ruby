require "spec_helper"

RSpec.describe "form components" do
  include Klods::Builders

  describe "form" do
    it "renders a klods-form element" do
      expect(form.to_s).to include("klods-form")
      expect(form.to_s).to start_with("<form")
    end
  end

  describe "field" do
    it "renders label and input" do
      node = field({label: "Email", required: true}) { |id| input(id: id, type: "email") }
      html = node.to_s
      expect(html).to include("klods-field")
      expect(html).to include("klods-label--required")
      expect(html).to include('type="email"')
      expect(html).to include("<label")
    end

    it "wires aria-invalid and aria-describedby when error is present" do
      node = field({label: "Name", error: "Required"}) { |id| input(id: id, type: "text") }
      html = node.to_s
      expect(html).to include('aria-invalid="true"')
      expect(html).to include("aria-describedby")
      expect(html).to include("klods-field--invalid")
      expect(html).to include("klods-error")
    end

    it "renders help text when provided" do
      node = field({label: "Bio", help: "Max 200 chars"}) { |id| textarea(id: id) }
      expect(node.to_s).to include("klods-help")
      expect(node.to_s).to include("Max 200 chars")
    end

    it "links label for to input id" do
      node = field({label: "Username"}) { |id| input(id: id) }
      html = node.to_s
      id_match = html.match(/id="([^"]+)"/)&.captures&.first
      expect(html).to include(%(for="#{id_match}"))
    end
  end

  describe "input" do
    it "renders a text input" do
      expect(input(type: "text").to_s).to include('type="text"')
      expect(input(type: "text").to_s).to include("klods-input")
    end

    it "renders a range input with output" do
      html = input(type: "range", value: "30").to_s
      expect(html).to include("klods-input--range")
      expect(html).to include("<output")
      expect(html).to include("30")
    end

    it "renders a color input with output" do
      html = input(type: "color", value: "#ff0000").to_s
      expect(html).to include("klods-input--color")
      expect(html).to include("<output")
    end
  end

  describe "select" do
    it "wraps select in a klods-select-wrapper div" do
      html = select([option({value: "a"}, "A")]).to_s
      expect(html).to include("klods-select-wrapper")
      expect(html).to include("klods-select")
      expect(html).to start_with("<div")
    end
  end

  describe "checkbox" do
    it "renders a label wrapping a checkbox input" do
      html = checkbox({label: "Accept", name: "accept", value: "1"}).to_s
      expect(html).to include('type="checkbox"')
      expect(html).to include("klods-checkbox")
      expect(html).to include("Accept")
    end

    it "renders checked state" do
      expect(checkbox({label: "On", checked: true}).to_s).to include(" checked")
    end
  end

  describe "radio" do
    it "renders a label wrapping a radio input" do
      html = radio({label: "Option A", name: "choice", value: "a"}).to_s
      expect(html).to include('type="radio"')
      expect(html).to include("klods-radio")
    end
  end

  describe "radio_group" do
    it "renders a group with legend" do
      node = radio_group({legend: "Colour"}, [radio({label: "Red", name: "colour"})])
      html = node.to_s
      expect(html).to include('role="group"')
      expect(html).to include("aria-labelledby")
      expect(html).to include("Colour")
    end
  end

  describe "switch_input" do
    it "renders switch with track and label spans" do
      html = switch_input({label: "Enabled", name: "enabled"}).to_s
      expect(html).to include("klods-switch")
      expect(html).to include('role="switch"')
      expect(html).to include("klods-switch__track")
      expect(html).to include("klods-switch__label")
    end

    it "renders reverse modifier" do
      expect(switch_input({label: "X", reverse: true}).to_s).to include("klods-switch--reverse")
    end
  end
end
