module Klods
  module Utilities
    def push(a = nil, b = nil, &block)
      props, children = Core.normalize_args(a, b)
      children = klods_capture(&block) if block
      Core.build(tag: "span", base: "klods-push", props: props, children: children)
    end

    def fill(a = nil, b = nil, &block)
      props, children = Core.normalize_args(a, b)
      children = klods_capture(&block) if block
      Core.build(tag: "div", base: "klods-fill", props: props, children: children)
    end
  end
end
