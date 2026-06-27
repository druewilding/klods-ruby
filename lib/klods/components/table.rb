module Klods
  module Components
    module Table
      def table_wrap(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(tag: "div", base: "klods-table-wrap", props: props, children: children)
      end

      def table(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.build(
          tag: "table", base: "klods-table",
          modifiers: {
            striped: "klods-table--striped",
            dense: "klods-table--dense"
          },
          props: props, children: children
        )
      end

      def thead(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.el("thead", props, children)
      end

      def tbody(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.el("tbody", props, children)
      end

      def tr(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.el("tr", props, children)
      end

      def th(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.el("th", props, children)
      end

      def td(a = nil, b = nil, &block)
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.el("td", props, children)
      end
    end
  end
end
