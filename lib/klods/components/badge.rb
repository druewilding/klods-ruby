module Klods
  module Components
    module Badge
      def badge(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(
          tag: "span", base: "klods-badge",
          modifiers: {
            variant: ->(v) { (v && v.to_s != "default") ? "klods-badge--#{v}" : nil }
          },
          props: props, children: children
        )
      end
    end
  end
end
