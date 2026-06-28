module Klods
  class FormBuilder < ActionView::Helpers::FormBuilder
    # Renders a fully wired klods form field: wrapper div, label, input, and
    # optional help/error text. Error state is read from object.errors automatically.
    #
    # = f.klods_field :email, label: "Email", type: :email, autocomplete: "email"
    # = f.klods_field :password, label: "Password", type: :password, required: true
    # = f.klods_field :bio, label: "Bio", type: :textarea
    # = f.klods_field :name, label: "Name", help: "Your display name"
    def klods_field(method, label: nil, type: :text, help: nil, required: false, **options)
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
          send(input_helper_for(type), method, class: "klods-input", **aria, **options) +
          (help && !is_invalid ? @template.content_tag(:p, help, id: help_id, class: "klods-help") : "".html_safe) +
          (error_msg ? @template.content_tag(:p, error_msg, id: error_id, class: "klods-error", role: "alert") : "".html_safe)
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

    def input_helper_for(type)
      {
        email: :email_field,
        password: :password_field,
        tel: :phone_field,
        url: :url_field,
        number: :number_field,
        date: :date_field,
        time: :time_field,
        search: :search_field,
        textarea: :text_area
      }.fetch(type, :text_field)
    end
  end
end
