module Klods
  module Components
    module Link
      def link(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(
          tag: "a", base: "klods-link",
          modifiers: {plain: "klods-link--plain"},
          props: props, children: children
        )
      end
    end
  end
end
