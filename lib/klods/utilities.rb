module Klods
  module Utilities
    def push(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(tag: "span", base: "klods-push", props: props, children: children)
    end

    def fill(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(tag: "div", base: "klods-fill", props: props, children: children)
    end
  end
end
