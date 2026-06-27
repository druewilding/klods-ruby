module Klods
  module Components
    module Tooltip
      # tooltip(props, children) — renders the static HTML structure.
      # Visibility is toggled by data-open via client JS; event wiring is omitted here.
      def tooltip(props, children)
        props = props.transform_keys(&:to_s)
        tip = props.delete("tip")
        position = props.delete("position") || "above"
        extra_class = props.delete("class")

        id = _next_tooltip_id
        tip_node = Core.el(
          "span",
          { "id" => id, "role" => "tooltip", "class" => "klods-tooltip__tip klods-tooltip__tip--#{position}" },
          tip
        )

        cls = Core.class_names("klods-tooltip", Core.resolve_class(extra_class))
        attrs = props.merge(
          "class" => cls.empty? ? nil : cls,
          "aria-describedby" => id
        ).compact

        Core.el("span", attrs, [children, tip_node])
      end

      private

      def _next_tooltip_id
        Thread.current[:klods_tooltip_counter] = (Thread.current[:klods_tooltip_counter] || 0) + 1
        "klods-tip-#{Thread.current[:klods_tooltip_counter]}"
      end
    end
  end
end
