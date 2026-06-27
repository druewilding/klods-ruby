module Klods
  module Components
    module Box
      def box(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(tag: "div", base: "klods-box", props: props, children: children)
      end
    end
  end
end
