module Klods
  module Components
    module Avatar
      AVATAR_SIZE_PX = {"small" => 12, "medium" => 20, "large" => 32}.freeze
      USER_SVG_INNER = '<circle cx="8" cy="6" r="2.5" stroke="currentColor" stroke-width="1.5"/>' \
        '<path stroke="currentColor" stroke-width="1.5" stroke-linecap="round" d="M2.5 14c0-2.8 2.5-5 5.5-5s5.5 2.2 5.5 5"/>'.freeze

      private_constant :AVATAR_SIZE_PX, :USER_SVG_INNER

      def avatar(props = nil)
        props = (props || {}).transform_keys(&:to_s)
        src = props.delete("src")
        name = props.delete("name")
        size = (props.delete("size") || "medium").to_s
        extra_class = props.delete("class")

        has_initials = src.nil? && !name.nil?
        cls = Core.class_names(
          "klods-avatar",
          (size != "medium") ? "klods-avatar--#{size}" : nil,
          has_initials ? "klods-avatar--initials" : nil,
          Core.resolve_class(extra_class)
        )

        content = if src
          Core.el("img", {"src" => src, "alt" => name.to_s, "class" => "klods-avatar__img"})
        elsif name
          initials = name.strip.split(/\s+/).first(2).map { |w| w[0]&.upcase || "" }.join
          Core.el("span", {"aria-hidden" => "true"}, initials)
        else
          px = AVATAR_SIZE_PX[size] || 20
          svg = %(<svg width="#{px}" height="#{px}" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">#{USER_SVG_INNER}</svg>)
          Core.el("span", {"aria-hidden" => "true", "class" => "klods-icon"}, Core.raw(svg))
        end

        span_attrs = props.merge("class" => cls.empty? ? nil : cls).compact
        if has_initials
          span_attrs["role"] = "img"
          span_attrs["aria-label"] = name
        end

        Core.el("span", span_attrs, content)
      end
    end
  end
end
