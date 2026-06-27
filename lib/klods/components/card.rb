module Klods
  module Components
    module Card
      def card(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(
          tag: "div", base: "klods-card",
          modifiers: { elevated: "klods-card--elevated" },
          props: props, children: children
        )
      end

      def card_title(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "h3", base: "klods-card__title", props: props, children: children)
      end

      def card_body(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "div", base: "klods-card__body", props: props, children: children)
      end

      def card_footer(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "div", base: "klods-card__footer", props: props, children: children)
      end
    end
  end
end
