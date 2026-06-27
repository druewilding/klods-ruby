module Klods
  module Components
    module Badge
      def badge(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
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
