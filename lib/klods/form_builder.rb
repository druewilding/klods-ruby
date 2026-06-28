module Klods
  class FormBuilder < ActionView::Helpers::FormBuilder
    # Renders a fully wired klods input field: wrapper div, label, input, and
    # optional help/error text. For textarea use f.klods_textarea; for select use f.klods_select.
    #
    # = f.klods_field :email, label: "Email", type: :email, autocomplete: "email"
    # = f.klods_field :password, label: "Password", type: :password, required: true
    # = f.klods_field :name, label: "Name", help: "Your display name"
    def klods_field(method, label: nil, type: :text, help: nil, required: false, **options)
      render_klods_wrapper(method, label: label, help: help, required: required) do |aria|
        send(input_helper_for(type), method, class: "klods-input", **aria, **options)
      end
    end

    # Renders a klods textarea field with wrapper, label, and error/help wiring.
    #
    # = f.klods_textarea :bio, label: "Bio", help: "Tell us about yourself"
    def klods_textarea(method, label: nil, help: nil, required: false, **options)
      render_klods_wrapper(method, label: label, help: help, required: required) do |aria|
        render_textarea_input(method, class: "klods-textarea", **aria, **options)
      end
    end

    # Renders a klods select field with wrapper, label, and error/help wiring.
    # choices is an array of ["Label", value] pairs (or plain values).
    #
    # = f.klods_select :role, [["Admin", "admin"], ["User", "user"]], label: "Role"
    def klods_select(method, choices = [], label: nil, help: nil, required: false, **options)
      render_klods_wrapper(method, label: label, help: help, required: required) do |aria|
        select_el = render_select_input(method, choices, class: "klods-select", **aria, **options)
        @template.content_tag(:div, select_el, class: "klods-select-wrapper")
      end
    end

    # Renders a submit button styled as a primary klods button.
    #
    # = f.klods_submit "Save"
    # = f.klods_submit "Sign up", class: "klods-button--wide"  # extra class merged in
    def klods_submit(label = nil, **options)
      extra = options.delete(:class)
      options[:class] = ["klods-button", "klods-button--primary", extra].compact.join(" ")
      submit(label, **options)
    end

    private

    def render_klods_wrapper(method, label:, help:, required:, &input_block)
      errors = Array(object&.errors&.[](method))
      error_msg = errors.first
      is_invalid = !error_msg.nil?

      id = field_id(method)
      help_id = "#{id}-help" if help
      error_id = "#{id}-error" if is_invalid

      aria = {}
      aria["aria-describedby"] = is_invalid ? error_id : help_id if error_id || help_id
      aria["aria-invalid"] = "true" if is_invalid

      field_cls = ["klods-field", ("klods-field--invalid" if is_invalid)].compact.join(" ")
      label_cls = ["klods-label", ("klods-label--required" if required)].compact.join(" ")

      @template.content_tag(:div, class: field_cls) do
        label(method, label || method.to_s.humanize, class: label_cls) +
          input_block.call(aria) +
          ((help && !is_invalid) ? @template.content_tag(:p, help, id: help_id, class: "klods-help") : "".html_safe) +
          (error_msg ? @template.content_tag(:p, error_msg, id: error_id, class: "klods-error", role: "alert") : "".html_safe)
      end
    end

    def input_helper_for(type)
      {
        email: :email_field,
        password: :password_field,
        tel: :phone_field,
        url: :url_field,
        number: :number_field,
        date: :date_field,
        time: :time_field,
        search: :search_field
      }.fetch(type, :text_field)
    end

    # Rails 8 FormBuilder#text_area calls @template.textarea(...), which is shadowed
    # by the klods textarea builder. Build the textarea directly to avoid the conflict.
    def render_textarea_input(method, **options)
      name = @object_name.present? ? "#{@object_name}[#{method}]" : method.to_s
      value = object&.public_send(method).to_s
      @template.content_tag(:textarea, value, name: name, id: field_id(method), **options)
    end

    # FormBuilder#select calls @template.select(...), which is shadowed by the klods
    # select builder. Build the select directly using options_for_select + content_tag.
    def render_select_input(method, choices, **options)
      name = @object_name.present? ? "#{@object_name}[#{method}]" : method.to_s
      selected = object&.public_send(method)
      options_html = @template.options_for_select(choices, selected)
      @template.content_tag(:select, options_html, name: name, id: field_id(method), **options)
    end
  end
end
