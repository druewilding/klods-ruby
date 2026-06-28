module Klods
  module Components
    module Nav
      MENU_SVG = '<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">' \
        '<rect y="3" width="20" height="2" rx="1" fill="currentColor"/>' \
        '<rect y="9" width="20" height="2" rx="1" fill="currentColor"/>' \
        '<rect y="15" width="20" height="2" rx="1" fill="currentColor"/>' \
        "</svg>"

      private_constant :MENU_SVG

      def nav(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(
          tag: "nav", base: "klods-nav",
          modifiers: {collapse: "klods-nav--collapse"},
          props: props, children: children
        )
      end

      def nav_list(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(tag: "ul", base: "klods-nav__list", props: props, children: children)
      end

      def nav_link(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        link = Core.build(
          tag: "a", base: "klods-nav__link",
          modifiers: {active: "klods-nav__link--active"},
          props: props, children: children
        )
        Core.el("li", {}, link)
      end

      def nav_toggle(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        props = {"type" => "button", "aria-label" => "Toggle navigation", "class" => "klods-nav__toggle"}
          .merge(props.transform_keys(&:to_s))
        default_icon = Core.el("span", {"aria-hidden" => "true", "class" => "klods-icon"}, Core.raw(MENU_SVG))
        Core.el("button", props, children || default_icon)
      end
    end
  end
end
