module Klods
  module Components
    module Form
      FORM_CONTROLS = %w[input select textarea].freeze
      private_constant :FORM_CONTROLS

      def form(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(tag: "form", base: "klods-form", props: props, children: children)
      end

      # field({ label: "Email", required: true }) { |id| input(id: id, type: "email") }
      def field(props, &block)
        props = props.transform_keys(&:to_s)
        label_text = props.delete("label")
        explicit_id = props.delete("id")
        help = props.delete("help")
        error = props.delete("error")
        required = props.delete("required")
        invalid = props.delete("invalid")
        extra_class = props.delete("class")

        id = explicit_id || Core.slug_id("klods-field", label_text.to_s)
        help_id = help ? "#{id}-help" : nil
        error_id = error ? "#{id}-error" : nil
        is_invalid = invalid || !!error

        described_by = is_invalid ? error_id : help_id

        aria_attrs = {}
        aria_attrs["aria-describedby"] = described_by if described_by
        aria_attrs["aria-invalid"] = "true" if is_invalid

        input_node = block.call(id)
        patched = _patch_aria_attrs(input_node, aria_attrs)

        field_cls = Core.class_names("klods-field", is_invalid ? "klods-field--invalid" : nil, Core.resolve_class(extra_class))
        label_cls = "klods-label#{" klods-label--required" if required}"

        children = [
          Core.el("label", {"for" => id, "class" => label_cls}, label_text),
          patched
        ]
        children << Core.el("p", {"id" => help_id, "class" => "klods-help"}, help) if help
        children << Core.el("p", {"id" => error_id, "class" => "klods-error", "role" => "alert"}, error) if error

        Core.el("div", props.merge("class" => field_cls.empty? ? nil : field_cls).compact, children)
      end

      def input(props = {})
        props = props.transform_keys(&:to_s)
        type = props.delete("type")
        extra_class = props.delete("class")

        id = props["id"] || Core.slug_id(
          "klods-input",
          (props["aria-label"] || props["placeholder"] || type || "field").to_s
        )
        props["id"] = id

        cls = lambda do |extra = ""|
          Core.class_names("klods-input", extra, Core.resolve_class(extra_class)).then { |c| c.empty? ? nil : c }
        end

        case type
        when "range"
          initial = props["value"] || "50"
          Node.new("span", {"class" => cls.call("klods-input--range")}, [
            Node.new("input", props.merge("type" => "range"), nil),
            Core.el("output", {"for" => id}, initial.to_s)
          ])
        when "color"
          initial = props["value"] || "#000000"
          Node.new("span", {"class" => cls.call("klods-input--color")}, [
            Node.new("input", props.merge("type" => "color"), nil),
            Core.el("output", {"for" => id}, initial.to_s)
          ])
        else
          Node.new("input", props.merge("type" => type, "class" => cls.call).compact)
        end
      end

      def select(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        inner = Core.build(tag: "select", base: "klods-select", props: props, children: children)
        Core.el("div", {"class" => "klods-select-wrapper"}, inner)
      end

      def option(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.el("option", props, children)
      end

      def textarea(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(tag: "textarea", base: "klods-textarea", props: props, children: children)
      end

      def checkbox(props)
        props = props.transform_keys(&:to_s)
        label_text = props.delete("label")
        extra_class = props.delete("class")

        input_attrs = {"type" => "checkbox"}
        %w[name value checked disabled required form autofocus].each do |key|
          val = props.delete(key)
          input_attrs[key] = val unless val.nil?
        end

        cls = Core.class_names("klods-checkbox", Core.resolve_class(extra_class))
        Core.el(
          "label",
          props.merge("class" => cls.empty? ? nil : cls).compact,
          [Node.new("input", input_attrs), Core.el("span", {}, label_text)]
        )
      end

      def radio(props)
        props = props.transform_keys(&:to_s)
        label_text = props.delete("label")
        extra_class = props.delete("class")

        input_attrs = {"type" => "radio"}
        %w[name value checked disabled required form autofocus].each do |key|
          val = props.delete(key)
          input_attrs[key] = val unless val.nil?
        end

        cls = Core.class_names("klods-radio", Core.resolve_class(extra_class))
        Core.el(
          "label",
          props.merge("class" => cls.empty? ? nil : cls).compact,
          [Node.new("input", input_attrs), Core.el("span", {}, label_text)]
        )
      end

      def radio_group(props, children)
        props = props.transform_keys(&:to_s)
        legend_text = props.delete("legend")
        extra_class = props.delete("class")
        legend_id = legend_text ? Core.slug_id("klods-rg", legend_text) : nil

        cls = Core.class_names("klods-field", Core.resolve_class(extra_class))
        attrs = props.merge("role" => "group", "class" => cls.empty? ? nil : cls).compact
        attrs["aria-labelledby"] = legend_id if legend_id

        group_children = []
        group_children << Core.el("p", {"id" => legend_id, "class" => "klods-label"}, legend_text) if legend_text
        group_children.concat(Array(children))

        Core.el("div", attrs, group_children)
      end

      def switch_input(props)
        props = props.transform_keys(&:to_s)
        label_text = props.delete("label")
        reverse = props.delete("reverse")
        extra_class = props.delete("class")

        input_attrs = {"type" => "checkbox", "class" => "klods-switch__input", "role" => "switch"}
        %w[name value checked disabled].each do |key|
          val = props.delete(key)
          input_attrs[key] = val unless val.nil?
        end

        cls = Core.class_names("klods-switch", reverse ? "klods-switch--reverse" : nil, Core.resolve_class(extra_class))
        Core.el(
          "label",
          props.merge("class" => cls.empty? ? nil : cls).compact,
          [
            Node.new("input", input_attrs),
            Core.el("span", {"class" => "klods-switch__track"}),
            Core.el("span", {"class" => "klods-switch__label"}, label_text)
          ]
        )
      end

      private

      def _patch_aria_attrs(node, aria_attrs)
        return node if aria_attrs.empty?

        if FORM_CONTROLS.include?(node.tag)
          Node.new(node.tag, node.attrs.merge(aria_attrs), node.children)
        else
          patched_children = node.children.map do |child|
            if child.is_a?(Node) && FORM_CONTROLS.include?(child.tag)
              Node.new(child.tag, child.attrs.merge(aria_attrs), child.children)
            else
              child
            end
          end
          Node.new(node.tag, node.attrs, patched_children)
        end
      end
    end
  end
end
