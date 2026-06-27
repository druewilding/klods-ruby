module Klods
  module Components
    module Tabs
      def tab_panel(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        label = props.delete(:label) || props.delete("label")
        attrs = label ? props.merge("data-tab-label" => label.to_s) : props
        Core.el("div", attrs, children)
      end

      def tabs(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        props = props.transform_keys(&:to_s)
        panels = Array(children).flatten.select { |c| c.is_a?(Node) }

        ns = props["id"] ? Core.slug_id("klods-tabs", props["id"].to_s) : "klods-tabs"

        items = panels.each_with_index.map do |panel, i|
          label = panel.attrs["data-tab-label"] || "Tab #{i + 1}"
          tab_id = Core.slug_id("#{ns}-tab", "#{label}-#{i + 1}")
          panel_id = Core.slug_id("#{ns}-panel", "#{label}-#{i + 1}")
          { panel: panel, label: label, tab_id: tab_id, panel_id: panel_id, active: i == 0 }
        end

        tab_list = Core.el(
          "div",
          { "class" => "klods-tabs__list", "role" => "tablist" },
          items.map do |item|
            tab_attrs = {
              "type" => "button",
              "role" => "tab",
              "id" => item[:tab_id],
              "aria-selected" => item[:active].to_s,
              "aria-controls" => item[:panel_id],
              "class" => item[:active] ? "klods-tabs__tab klods-tabs__tab--active" : "klods-tabs__tab"
            }
            tab_attrs["tabindex"] = "-1" unless item[:active]
            Core.el("button", tab_attrs, item[:label])
          end
        )

        panel_nodes = items.map do |item|
          panel = item[:panel]
          panel_attrs = panel.attrs.reject { |k, _| k == "data-tab-label" }
          extra_class = panel_attrs.delete("class")
          cls = Core.class_names("klods-tabs__panel", Core.resolve_class(extra_class))
          attrs = panel_attrs.merge(
            "class" => cls.empty? ? nil : cls,
            "role" => "tabpanel",
            "id" => item[:panel_id],
            "aria-labelledby" => item[:tab_id]
          ).compact
          attrs["hidden"] = true unless item[:active]
          Node.new("div", attrs, panel.children)
        end

        extra_class = props.delete("class")
        cls = Core.class_names("klods-tabs", Core.resolve_class(extra_class))
        Core.el("div", props.merge("class" => cls.empty? ? nil : cls).compact, [tab_list, *panel_nodes])
      end
    end
  end
end
