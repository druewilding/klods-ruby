module Klods
  module Components
    module Details
      def details(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(
          tag: "details", base: "klods-details",
          modifiers: { open: "klods-details--open" },
          props: props, children: children
        )
      end

      def summary(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.el("summary", props, children)
      end
    end
  end
end
