module Klods
  class RawHtml
    attr_reader :html
    def initialize(html) = @html = html.to_s
    def to_s = @html
    def to_str = @html
  end

  class Node
    attr_reader :tag, :attrs, :children

    VOID_TAGS = %w[area base br col embed hr img input link meta source track wbr].freeze

    def initialize(tag, attrs = {}, children = nil)
      @tag = tag.to_s
      @attrs = normalize_attrs(attrs)
      @children = VOID_TAGS.include?(@tag) ? [] : flatten_children(children)
    end

    def to_s
      parts = ["<#{@tag}"]

      @attrs.each do |name, value|
        next if value.nil? || value == false

        if name == "class"
          cls = resolve_class(value)
          parts << %( class="#{escape_attr(cls)}") unless cls.empty?
        elsif name == "style"
          parts << %( style="#{escape_attr(style_to_s(value))}")
        elsif value == true
          parts << " #{name}"
        else
          parts << %( #{name}="#{escape_attr(value.to_s)}")
        end
      end

      if VOID_TAGS.include?(@tag)
        parts << " />"
        return parts.join
      end

      parts << ">"
      @children.each { |child| parts << child_to_s(child) }
      parts << "</#{@tag}>"
      parts.join
    end

    alias_method :to_str, :to_s

    private

    def normalize_attrs(attrs)
      return {} if attrs.nil?
      attrs.transform_keys(&:to_s)
    end

    def flatten_children(children)
      return [] if children.nil?
      case children
      when Array then children.flatten.reject { |c| c.nil? || c == false || c == true }
      when false, true then []
      else [children]
      end
    end

    def child_to_s(child)
      case child
      when Node then child.to_s
      when RawHtml then child.html
      else escape_html(child.to_s)
      end
    end

    def escape_html(str)
      str.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;").gsub('"', "&quot;").gsub("'", "&#39;")
    end

    def escape_attr(str)
      str.gsub("&", "&amp;").gsub('"', "&quot;")
    end

    def resolve_class(input)
      case input
      when nil then ""
      when String then input.strip
      when Array then input.flatten.filter_map { |c| resolve_class(c) unless resolve_class(c).empty? }.join(" ")
      when Hash then input.filter_map { |k, v| k.to_s if v }.join(" ")
      else input.to_s.strip
      end
    end

    def style_to_s(style)
      return style.to_s if style.is_a?(String)
      style.filter_map { |k, v| "#{k.to_s.gsub(/([A-Z])/) { "-#{$1.downcase}" }}:#{v}" unless v.nil? || v == "" }.join(";")
    end
  end
end
