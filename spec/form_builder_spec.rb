require "spec_helper"
require "action_view"
require "active_model"
require "klods/form_builder"

class TestRecord
  include ActiveModel::Model

  attr_accessor :email, :password, :name, :bio, :role

  def self.model_name
    ActiveModel::Name.new(self, nil, "TestRecord")
  end
end

RSpec.describe Klods::FormBuilder do
  let(:template) do
    view = ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil)
    view.output_buffer = ActionView::OutputBuffer.new
    view
  end

  let(:record) { TestRecord.new }

  let(:builder) { described_class.new(:test_record, record, template, {}) }

  describe "#klods_field" do
    it "wraps in a klods-field div" do
      html = builder.klods_field(:email, type: :email)
      expect(html).to include('class="klods-field"')
    end

    it "renders a klods-label label" do
      html = builder.klods_field(:email, label: "Email address", type: :email)
      expect(html).to include('class="klods-label"')
      expect(html).to include("Email address")
    end

    it "humanizes the attribute name as the default label" do
      html = builder.klods_field(:email, type: :email)
      expect(html).to include("Email")
    end

    it "renders a klods-input input of the given type" do
      html = builder.klods_field(:email, type: :email)
      expect(html).to include('class="klods-input"')
      expect(html).to include('type="email"')
    end

    it "passes extra options through to the input" do
      html = builder.klods_field(:email, type: :email, autocomplete: "email", autofocus: true)
      expect(html).to include('autocomplete="email"')
      expect(html).to include("autofocus")
    end

    it "renders a password field" do
      html = builder.klods_field(:password, type: :password)
      expect(html).to include('type="password"')
    end

    it "shows help text when provided" do
      html = builder.klods_field(:email, type: :email, help: "Never shared with anyone")
      expect(html).to include('class="klods-help"')
      expect(html).to include("Never shared with anyone")
    end

    it "adds aria-describedby pointing at the help element" do
      html = builder.klods_field(:email, type: :email, help: "hint")
      expect(html).to match(/aria-describedby="test_record_email-help"/)
    end

    it "marks required fields with a label modifier" do
      html = builder.klods_field(:email, type: :email, required: true)
      expect(html).to include("klods-label--required")
    end

    context "when the object has validation errors" do
      before { record.errors.add(:email, "is invalid") }

      it "adds the invalid modifier to the field wrapper" do
        html = builder.klods_field(:email, type: :email)
        expect(html).to include("klods-field--invalid")
      end

      it "renders the error message with klods-error class" do
        html = builder.klods_field(:email, type: :email)
        expect(html).to include('class="klods-error"')
        expect(html).to include("is invalid")
      end

      it "adds aria-invalid to the input" do
        html = builder.klods_field(:email, type: :email)
        expect(html).to include('aria-invalid="true"')
      end

      it "adds aria-describedby pointing at the error element" do
        html = builder.klods_field(:email, type: :email)
        expect(html).to match(/aria-describedby="test_record_email-error"/)
      end

      it "does not render help text when there is an error" do
        html = builder.klods_field(:email, type: :email, help: "hint")
        expect(html).not_to include("klods-help")
      end
    end
  end

  describe "#klods_textarea" do
    it "wraps in a klods-field div" do
      html = builder.klods_textarea(:bio)
      expect(html).to include('class="klods-field"')
    end

    it "renders a textarea element with klods-textarea class" do
      html = builder.klods_textarea(:bio)
      expect(html).to include("<textarea")
      expect(html).to include('class="klods-textarea"')
    end

    it "does not use klods-input class" do
      html = builder.klods_textarea(:bio)
      expect(html).not_to include("klods-input")
    end

    it "shows help text" do
      html = builder.klods_textarea(:bio, help: "Max 500 characters")
      expect(html).to include("Max 500 characters")
    end

    context "when the object has validation errors" do
      before { record.errors.add(:bio, "is too long") }

      it "adds the invalid modifier" do
        html = builder.klods_textarea(:bio)
        expect(html).to include("klods-field--invalid")
      end

      it "adds aria-invalid to the textarea" do
        html = builder.klods_textarea(:bio)
        expect(html).to include('aria-invalid="true"')
      end
    end
  end

  describe "#klods_select" do
    let(:choices) { [["Alice", "alice"], ["Bob", "bob"]] }

    it "wraps in a klods-field div" do
      html = builder.klods_select(:name, choices)
      expect(html).to include('class="klods-field"')
    end

    it "wraps the select in a klods-select-wrapper div" do
      html = builder.klods_select(:name, choices)
      expect(html).to include('class="klods-select-wrapper"')
    end

    it "renders a select element with klods-select class" do
      html = builder.klods_select(:name, choices)
      expect(html).to include("<select")
      expect(html).to include('class="klods-select"')
    end

    it "does not use klods-input class" do
      html = builder.klods_select(:name, choices)
      expect(html).not_to include("klods-input")
    end

    it "renders the choices as options" do
      html = builder.klods_select(:name, choices)
      expect(html).to include("Alice")
      expect(html).to include("Bob")
    end

    it "marks the selected option from the object value" do
      record.name = "bob"
      html = builder.klods_select(:name, choices)
      expect(html).to include('selected="selected" value="bob"')
    end

    context "when the object has validation errors" do
      before { record.errors.add(:name, "is invalid") }

      it "adds the invalid modifier" do
        html = builder.klods_select(:name, choices)
        expect(html).to include("klods-field--invalid")
      end

      it "adds aria-invalid to the select" do
        html = builder.klods_select(:name, choices)
        expect(html).to include('aria-invalid="true"')
      end
    end
  end

  describe "#klods_submit" do
    it "renders a submit input with primary klods button classes" do
      html = builder.klods_submit("Save")
      expect(html).to include('class="klods-button klods-button--primary"')
      expect(html).to include('value="Save"')
    end

    it "merges extra classes" do
      html = builder.klods_submit("Save", class: "klods-button--wide")
      expect(html).to include("klods-button klods-button--primary klods-button--wide")
    end
  end
end
