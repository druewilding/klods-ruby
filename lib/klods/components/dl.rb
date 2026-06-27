module Klods
  module Components
    module Dl
      def dl(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(
          tag: "dl", base: "klods-dl",
          modifiers: {inline: "klods-dl--inline"},
          props: props, children: children
        )
      end

      def dt(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(tag: "dt", base: "klods-dt", props: props, children: children)
      end

      def dd(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(tag: "dd", base: "klods-dd", props: props, children: children)
      end
    end
  end
end
