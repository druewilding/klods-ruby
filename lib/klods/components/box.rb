module Klods
  module Components
    module Box
      def box(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        Core.build(tag: "div", base: "klods-box", props: props, children: children)
      end
    end
  end
end
