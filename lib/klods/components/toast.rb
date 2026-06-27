module Klods
  module Components
    module Toast
      # Renders the live region container. Mount this once in your layout;
      # individual toasts are appended inside it (via JS on the client, or
      # server-rendered for SSR pre-populated notifications).
      def toast_region(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        attrs = {
          "class" => "klods-toast-region",
          "aria-live" => "polite",
          "aria-atomic" => "false",
          "role" => "region",
          "aria-label" => "Notifications"
        }.merge(props.transform_keys(&:to_s))
        Core.el("div", attrs, children)
      end

      def toast(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        props = props.transform_keys(&:to_s)
        variant = props.delete("variant")
        extra_class = props.delete("class")
        cls = Core.class_names(
          "klods-toast",
          variant && variant.to_s != "default" ? "klods-toast--#{variant}" : nil,
          Core.resolve_class(extra_class)
        )
        attrs = props.merge("role" => "status", "class" => cls.empty? ? nil : cls).compact
        body = Core.el("span", { "class" => "klods-toast__body" }, children)
        close_btn = Core.el("button", { "type" => "button", "class" => "klods-toast__close", "aria-label" => "Dismiss" })
        Core.el("div", attrs, [body, close_btn])
      end
    end
  end
end
