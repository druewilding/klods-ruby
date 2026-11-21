module Klods
  module Components
    # A colored dot beside text, for a live state like "Your turn" or "Online".
    # The text must say the state on its own; add role: "status" when it changes
    # while the page is open, so screen readers announce it.
    module Status
      def status(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(
          tag: "span", base: "klods-status",
          modifiers: {
            variant: ->(v) { (v && v.to_s != "default") ? "klods-status--#{v}" : nil },
            pulse: "klods-status--pulse"
          },
          props: props, children: children
        )
      end
    end
  end
end
