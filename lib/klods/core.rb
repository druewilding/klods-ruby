module Klods
  module Core
    module_function

    def raw(html)
      RawHtml.new(html)
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

    def merge_classes(*inputs)
      inputs.map { |c| resolve_class(c) }.reject(&:empty?).join(" ")
    end

    def class_names(*parts)
      parts.flatten.compact.map(&:to_s).reject(&:empty?).join(" ")
    end

    # Splits (props_or_children, children?) into [props_hash, children].
    # A Hash first arg is props; anything else (string, array, Node, nil) is children.
    def normalize_args(a = nil, b = nil)
      if a.is_a?(Hash) || a.nil?
        [(a || {}), b]
      else
        [{}, a]
      end
    end

    def el(tag, a = nil, b = nil)
      props, children = normalize_args(a, b)
      Node.new(tag, props, children)
    end

    # BEM builder factory — resolves modifier props into BEM classes, passes
    # everything else through as HTML attributes.
    def build(tag:, base:, modifiers: {}, props: {}, children: nil)
      props = props.dup

      resolved_children = if children.nil?
        props.delete(:children) || props.delete("children")
      else
        props.delete(:children)
        props.delete("children")
        children
      end

      mod_classes = []
      passthrough = {}

      props.each do |key, value|
        sym = key.is_a?(Symbol) ? key : key.to_s.to_sym
        mod = modifiers[sym] || modifiers[key.to_s]
        if mod
          if mod.respond_to?(:call)
            cls = mod.call(value)
            mod_classes << cls if cls
          elsif value
            mod_classes << mod
          end
        else
          passthrough[key] = value
        end
      end

      user_class = passthrough.delete(:class) || passthrough.delete("class")
      final_class = merge_classes(base, *mod_classes, user_class)

      attrs = passthrough
      attrs["class"] = final_class unless final_class.empty?

      Node.new(tag, attrs, resolved_children)
    end

    def slug_id(prefix, text)
      safe = text.to_s
      slug = safe.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/^-|-$/, "")
      return "#{prefix}-#{slug}" unless slug.empty?

      h = 5381
      safe.each_char { |c| h = ((h << 5) + h + c.ord) & 0xffffffff }
      "#{prefix}-#{h.to_s(36)}"
    end
  end
end
