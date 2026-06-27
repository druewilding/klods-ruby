module Klods
  module Components
    module Alert
      def alert(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        merged = {"role" => "alert"}.merge(props.transform_keys(&:to_s))
        Core.build(
          tag: "div", base: "klods-alert",
          modifiers: {
            variant: ->(v) { (v && v.to_s != "default") ? "klods-alert--#{v}" : nil }
          },
          props: merged, children: children
        )
      end
    end
  end
end
