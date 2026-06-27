module Klods
  module Layout
    def page(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(
        tag: "div", base: "klods-page",
        modifiers: {
          sidebar: "klods-page--with-sidebar",
          sidebar_position: ->(v) { (v.to_s == "trailing") ? "klods-page--sidebar-trailing" : nil },
          sticky_header: "klods-page--sticky-header"
        },
        props: props, children: children
      )
    end

    def header(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(tag: "header", base: "klods-header", props: props, children: children)
    end

    def sidebar(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(tag: "aside", base: "klods-sidebar", props: props, children: children)
    end

    def content(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(
        tag: "main", base: "klods-content",
        modifiers: {narrow: "klods-content--narrow"},
        props: props, children: children
      )
    end

    def footer(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(tag: "footer", base: "klods-footer", props: props, children: children)
    end

    def section(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(tag: "section", base: "klods-section", props: props, children: children)
    end

    def stack(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(
        tag: "div", base: "klods-stack",
        modifiers: {gap: ->(v) { v ? "klods-stack--gap-#{v}" : nil }},
        props: props, children: children
      )
    end

    def cluster(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(
        tag: "div", base: "klods-cluster",
        modifiers: {gap: ->(v) { v ? "klods-cluster--gap-#{v}" : nil }},
        props: props, children: children
      )
    end

    def row(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(
        tag: "div", base: "klods-row",
        modifiers: {
          gap: ->(v) { v ? "klods-row--gap-#{v}" : nil },
          inline: "klods-row--inline"
        },
        props: props, children: children
      )
    end

    def grid(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(
        tag: "div", base: "klods-grid",
        modifiers: {
          gap: ->(v) { v ? "klods-grid--gap-#{v}" : nil },
          cols: ->(v) { v ? "klods-grid--cols-#{v}" : nil },
          fit: "klods-grid--fit"
        },
        props: props, children: children
      )
    end

    def center(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(tag: "div", base: "klods-center", props: props, children: children)
    end

    def spread(a = nil, b = nil)
      props, children = Core.normalize_args(a, b)
      Core.build(tag: "div", base: "klods-spread", props: props, children: children)
    end

    def text(value)
      Node.new("span", {}, [value.to_s])
    end

    def sidebar_toggle(attrs = nil)
      Core.el("button", {
        "type" => "button",
        "aria-label" => "Toggle sidebar",
        "class" => "klods-sidebar-toggle"
      }.merge((attrs || {}).transform_keys(&:to_s)))
    end
  end
end
