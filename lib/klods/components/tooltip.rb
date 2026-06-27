module Klods
  module Components
    module Tooltip
      def tooltip(props, children)
        props = props.transform_keys(&:to_s)
        tip = props.delete("tip")
        position = props.delete("position") || "above"
        extra_class = props.delete("class")

        id = _next_tooltip_id
        tip_node = Core.el(
          "span",
          {"id" => id, "role" => "tooltip", "class" => "klods-tooltip__tip klods-tooltip__tip--#{position}"},
          tip
        )

        # Inline JS mirrors showTooltip/hideTooltip from klods-js.
        # _kh (klods hide) is stored on the tip element to cancel pending hides.
        show_js = "var t=this.querySelector('[role=tooltip]');if(t){clearTimeout(t._kh);t.setAttribute('data-open','')}"
        hide_js = "var t=this.querySelector('[role=tooltip]');if(t){t._kh=setTimeout(()=>t.removeAttribute('data-open'),80)}"

        cls = Core.class_names("klods-tooltip", Core.resolve_class(extra_class))
        attrs = props.merge(
          "class" => cls.empty? ? nil : cls,
          "aria-describedby" => id,
          "onmouseenter" => show_js,
          "onmouseleave" => hide_js,
          "onfocusin" => show_js,
          "onfocusout" => "if(!this.contains(event.relatedTarget)){var t=this.querySelector('[role=tooltip]');if(t)t.removeAttribute('data-open')}"
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
