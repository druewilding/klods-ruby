module Klods
  module Components
    module Toc
      def toc(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(
          tag: "ul", base: "klods-toc",
          modifiers: {sub: "klods-toc--sub"},
          props: props, children: children
        )
      end

      def toc_item(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.el("li", props, children)
      end

      def toc_link(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(
          tag: "a", base: "klods-toc__link",
          modifiers: {active: "klods-toc__link--active"},
          props: props, children: children
        )
      end
    end
  end
end
