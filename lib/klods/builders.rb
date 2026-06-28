module Klods
  module Builders
    include Klods::Html
    include Klods::Layout
    include Klods::Utilities
    include Klods::Components::Alert
    include Klods::Components::Avatar
    include Klods::Components::Badge
    include Klods::Components::Box
    include Klods::Components::Breadcrumb
    include Klods::Components::Button
    include Klods::Components::Card
    include Klods::Components::Code
    include Klods::Components::Details
    include Klods::Components::Dl
    include Klods::Components::Form
    include Klods::Components::Link
    include Klods::Components::List
    include Klods::Components::Modal
    include Klods::Components::Nav
    include Klods::Components::Prose
    include Klods::Components::Table
    include Klods::Components::Tabs
    include Klods::Components::Toast
    include Klods::Components::Tooltip
    include Klods::Icons

    def el(tag, a = nil, b = nil)
      Core.el(tag, a, b)
    end

    def raw(html)
      Core.raw(html)
    end

    private

    # Captures the rendered output of a HAML/ERB block and returns it as a
    # single-element children array containing raw HTML. Relies on ActionView's
    # `capture` helper — returns nil outside a Rails view context so the caller
    # falls back to its regular children argument.
    def klods_capture(&block)
      return nil unless block
      return nil unless respond_to?(:capture)
      [Core.raw(capture(&block).to_s)]
    end
  end
end
