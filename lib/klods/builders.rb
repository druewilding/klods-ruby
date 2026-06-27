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
  end
end
