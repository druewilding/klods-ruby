module Klods
  module Components
    module Button
      BUTTON_MODIFIERS = {
        variant: ->(v) { (v && v.to_s != "default") ? "klods-button--#{v}" : nil }
      }.freeze

      def button(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        str_props = props.transform_keys(&:to_s)
        if str_props.key?("href")
          Core.build(tag: "a", base: "klods-button", modifiers: BUTTON_MODIFIERS, props: str_props, children: children)
        else
          Core.build(
            tag: "button", base: "klods-button", modifiers: BUTTON_MODIFIERS,
            props: {"type" => "button"}.merge(str_props), children: children
          )
        end
      end

      def button_group(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "div", base: "klods-button-group", props: props, children: children)
      end
    end
  end
end
