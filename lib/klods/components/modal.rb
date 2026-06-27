module Klods
  module Components
    module Modal
      def modal(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        props = props.transform_keys(&:to_s)
        open_attr = props.delete("open")
        extra_class = props.delete("class")
        cls = Core.class_names("klods-modal", Core.resolve_class(extra_class))
        attrs = props.merge("class" => cls.empty? ? nil : cls).compact
        attrs["open"] = true if open_attr
        Core.el("dialog", attrs, children)
      end

      def modal_panel(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "div", base: "klods-modal__panel", props: props, children: children)
      end

      def modal_header(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "div", base: "klods-modal__header", props: props, children: children)
      end

      def modal_title(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "h2", base: "klods-modal__title", props: props, children: children)
      end

      def modal_body(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "div", base: "klods-modal__body", props: props, children: children)
      end

      def modal_actions(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "div", base: "klods-modal__actions", props: props, children: children)
      end

      # Close button — the × icon is provided by CSS via a ::before mask-image.
      # Closes the containing dialog automatically via inline JS.
      def modal_close(attrs = nil)
        attrs = (attrs || {}).transform_keys(&:to_s)
        extra_class = attrs.delete("class")
        cls = Core.class_names("klods-modal__close", Core.resolve_class(extra_class))
        final_attrs = {
          "type" => "button",
          "aria-label" => "Close",
          "onclick" => "this.closest('dialog').close()"
        }
          .merge(attrs)
          .merge("class" => cls.empty? ? nil : cls)
          .compact
        Core.el("button", final_attrs)
      end

      # Button that opens the next sibling <dialog> as a modal when clicked.
      # Accepts the same props as button (e.g. variant:).
      def modal_trigger(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        merged = {
          "type" => "button",
          "onclick" => "this.nextElementSibling.showModal()"
        }.merge(props.transform_keys(&:to_s))
        Core.build(
          tag: "button", base: "klods-button",
          modifiers: {
            variant: ->(v) { (v && v.to_s != "default") ? "klods-button--#{v}" : nil }
          },
          props: merged, children: children
        )
      end
    end
  end
end
