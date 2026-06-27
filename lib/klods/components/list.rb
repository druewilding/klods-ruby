module Klods
  module Components
    module List
      def list(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(
          tag: "ul", base: "klods-list",
          modifiers: { flush: "klods-list--flush" },
          props: props, children: children
        )
      end

      def list_item(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        props = props.transform_keys(&:to_s)

        lead  = props.delete("lead")
        trail = props.delete("trail")
        href  = props.delete("href")
        extra_class = props.delete("class")

        li_cls = Core.class_names(
          "klods-list__item",
          href ? "klods-list__item--link" : nil,
          Core.resolve_class(extra_class)
        )

        has_slots = !lead.nil? || !trail.nil?

        build_slots = lambda do
          parts = []
          parts << Core.el("span", { "class" => "klods-list__lead" }, lead) if lead
          parts << Core.el("span", { "class" => "klods-list__content" }, children)
          parts << Core.el("span", { "class" => "klods-list__trail" }, trail) if trail
          parts
        end

        li_attrs = props.merge("class" => li_cls.empty? ? nil : li_cls).compact

        if href
          link_content = has_slots ? build_slots.call : children
          return Core.el("li", li_attrs,
            Core.el("a", { "href" => href, "class" => "klods-list__link" }, link_content)
          )
        end

        Core.el("li", li_attrs, has_slots ? build_slots.call : children)
      end
    end
  end
end
