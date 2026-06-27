module Klods
  module Components
    module Button
      def button(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        merged = { "type" => "button" }.merge(props.transform_keys(&:to_s))
        Core.build(
          tag: "button", base: "klods-button",
          modifiers: {
            variant: ->(v) { v && v.to_s != "default" ? "klods-button--#{v}" : nil }
          },
          props: merged, children: children
        )
      end

      def button_group(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "div", base: "klods-button-group", props: props, children: children)
      end
    end
  end
end
