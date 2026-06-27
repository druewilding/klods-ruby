module Klods
  module Components
    module Breadcrumb
      def crumb(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        href = props.delete(:href) || props.delete("href")
        attrs = href ? props.merge("data-crumb-href" => href) : props
        Core.el("li", attrs, children)
      end

      def breadcrumbs(crumbs, attrs = {})
        items = crumbs.each_with_index.map do |crumb_node, i|
          is_last = i == crumbs.length - 1
          href = crumb_node.attrs["data-crumb-href"]
          item_attrs = crumb_node.attrs.except("data-crumb-href")
          extra_class = item_attrs.delete("class")

          content = if href && !is_last
            [Core.el("a", {"href" => href, "class" => "klods-breadcrumb__link"}, crumb_node.children)]
          else
            crumb_node.children
          end

          cls = Core.class_names("klods-breadcrumb__item", Core.resolve_class(extra_class))
          final_attrs = item_attrs.merge("class" => cls.empty? ? nil : cls)
          final_attrs["aria-current"] = "page" if is_last
          final_attrs.compact!

          Node.new("li", final_attrs, content)
        end

        attrs = attrs.transform_keys(&:to_s)
        aria_label = attrs.delete("aria-label") || "Breadcrumb"
        extra_class = attrs.delete("class")
        cls = Core.resolve_class(extra_class)

        nav_attrs = attrs.merge("aria-label" => aria_label)
        nav_attrs["class"] = cls unless cls.empty?

        Core.el("nav", nav_attrs, Core.el("ol", {"class" => "klods-breadcrumb__list"}, items))
      end
    end
  end
end
