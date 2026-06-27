module Klods
  module Components
    module Prose
      def prose(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "div", base: "klods-prose", props: props, children: children)
      end

      def muted(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "span", base: "klods-muted", props: props, children: children)
      end

      def lead(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "p", base: "klods-lead", props: props, children: children)
      end

      def text_center(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "div", base: "klods-text-center", props: props, children: children)
      end
    end
  end
end
