module Klods
  module Components
    # A row of radio buttons drawn as one pill, for picking one of a few short
    # options. Arrow keys move between them, and the choice is sent with a form.
    #
    #   segmented({name: "theme", label: "Theme", value: "auto",
    #              options: [{label: "Auto", value: "auto"}, {label: "Dark", value: "dark"}]})
    #   segmented({name: "view", "aria-labelledby": "view-label", options: ["Day", "Week"]})
    #
    # An option is a string (its text and value) or a hash with label, and
    # optionally value and disabled. Use label: to name the group for screen
    # readers, or aria-labelledby when a visible label names it.
    module Segmented
      def segmented(props)
        props = props.transform_keys(&:to_s)
        name = props.delete("name")
        options = props.delete("options") || []
        value = props.delete("value")
        label = props.delete("label")
        disabled = props.delete("disabled")
        extra_class = props.delete("class")

        items = options.map do |option|
          option = option.is_a?(Hash) ? option.transform_keys(&:to_s) : {"label" => option}
          text = option["label"]
          option_value = option.fetch("value", text)

          input_attrs = {"type" => "radio", "class" => "klods-segmented__input", "name" => name, "value" => option_value}
          input_attrs["checked"] = true if option_value == value
          input_attrs["disabled"] = true if disabled || option["disabled"]
          Core.el("label", {"class" => "klods-segmented__option"}, [Node.new("input", input_attrs), text])
        end

        cls = Core.class_names("klods-segmented", Core.resolve_class(extra_class))
        attrs = props.merge("role" => "radiogroup")
        attrs["aria-label"] = label unless label.nil?
        attrs["class"] = cls.empty? ? nil : cls
        Core.el("div", attrs.compact, items)
      end
    end
  end
end
