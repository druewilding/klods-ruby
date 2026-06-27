module Klods
  # Raw HTML tag shortcuts — no BEM classes, just the element.
  # Mirrors html.ts in klods-js. Tags that share a name with a klods component
  # (nav, button, form, header, footer, section, table, thead, tbody, tr, th,
  # td, input, select, textarea, details, summary, dl, dt, dd) are intentionally
  # omitted — use the klods component or Core.el("tag", ...) for the bare element.
  module Html
    %w[a abbr address article b blockquote br caption cite code col colgroup
      data dfn div em figcaption figure h1 h2 h3 h4 h5 h6 hr i img ins
      legend li mark ol p pre q s small span strong sub sup time u ul].each do |tag|
      define_method(tag) do |a = nil, b = nil, &block|
        props, children = Core.normalize_args(a, b)
        children = klods_capture(&block) if block
        Core.el(tag, props, children)
      end
    end

    # `var` is a reserved word in some linters; named var_el to match klods-js.
    def var_el(a = nil, b = nil, &block)
      props, children = Core.normalize_args(a, b)
      children = klods_capture(&block) if block
      Core.el("var", props, children)
    end
  end
end
