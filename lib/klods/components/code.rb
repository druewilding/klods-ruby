module Klods
  module Components
    module Code
      def code_block(a = nil, b = nil)
        props, content = Core.normalize_args(a, b)
        props = props.transform_keys(&:to_s)
        extra_class = props.delete("class")
        cls = Core.class_names("klods-pre", Core.resolve_class(extra_class))
        attrs = props.merge("class" => cls.empty? ? nil : cls).compact
        Core.el("pre", attrs, Core.el("code", {}, content))
      end

      def inline_code(a = nil, b = nil)
        props, content = Core.normalize_args(a, b)
        props = props.transform_keys(&:to_s)
        extra_class = props.delete("class")
        cls = Core.class_names("klods-code", Core.resolve_class(extra_class))
        attrs = props.merge("class" => cls.empty? ? nil : cls).compact
        Core.el("code", attrs, content)
      end

      def kbd(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "kbd", base: "klods-kbd", props: props, children: children)
      end

      def samp(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "samp", base: "klods-samp", props: props, children: children)
      end

      def var_el(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "var", base: "klods-var", props: props, children: children)
      end
    end
  end
end
