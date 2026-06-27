module Klods
  module Icons
    SIZE_PX = { "small" => 12, "medium" => 20, "large" => 32 }.freeze

    private_constant :SIZE_PX

    def self._make_icon(svg_inner, view_box)
      lambda do |props = nil|
        props = props ? props.dup : {}
        size = (props.delete(:size) || props.delete("size") || "medium").to_s
        label = props.delete(:label) || props.delete("label")
        extra_class = props.delete(:class) || props.delete("class")
        px = SIZE_PX[size] || 20
        aria = label ? { "aria-label" => label.to_s, "role" => "img" } : { "aria-hidden" => "true" }
        cls = Core.class_names("klods-icon", Core.resolve_class(extra_class))
        attrs = props.transform_keys(&:to_s).merge(aria)
        attrs["class"] = cls unless cls.empty?
        svg = %(<svg width="#{px}" height="#{px}" viewBox="#{view_box}" fill="none" xmlns="http://www.w3.org/2000/svg">#{svg_inner}</svg>)
        Core.el("span", attrs, Core.raw(svg))
      end
    end

    CHECK_CIRCLE_ICON = _make_icon(
      '<circle cx="8" cy="8" r="6" stroke="currentColor" stroke-width="1.5"/><path stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" d="M5 8l2 2.5 4-4"/>',
      "0 0 16 16"
    )
    CHEV_DOWN_ICON = _make_icon(
      '<path stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="M2 5l6 6 6-6"/>',
      "0 0 16 16"
    )
    CHEV_LEFT_ICON = _make_icon(
      '<path stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="M11 2l-6 6 6 6"/>',
      "0 0 16 16"
    )
    CHEV_RIGHT_ICON = _make_icon(
      '<path stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="M5 2l6 6-6 6"/>',
      "0 0 16 16"
    )
    CHEV_UP_ICON = _make_icon(
      '<path stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="M2 11l6-6 6 6"/>',
      "0 0 16 16"
    )
    CLOSE_ICON = _make_icon(
      '<path stroke="currentColor" stroke-linecap="round" stroke-width="1.75" d="M4 4l8 8M12 4L4 12"/>',
      "0 0 16 16"
    )
    COPY_ICON = _make_icon(
      '<rect x="5" y="5" width="8" height="8" rx="1.5" stroke="currentColor" stroke-width="1.5"/><path stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" d="M11 5V3.5A1.5 1.5 0 009.5 2h-6A1.5 1.5 0 002 3.5v6A1.5 1.5 0 003.5 11H5"/>',
      "0 0 16 16"
    )
    DANGER_CIRCLE_ICON = _make_icon(
      '<circle cx="8" cy="8" r="6" stroke="currentColor" stroke-width="1.5"/><path stroke="currentColor" stroke-width="1.5" stroke-linecap="round" d="M5.5 5.5l5 5M10.5 5.5l-5 5"/>',
      "0 0 16 16"
    )
    EDIT_ICON = _make_icon(
      '<path stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" d="M11.3 2a2 2 0 112.8 2.8L5 13.8l-3.5 1 1-3.5L11.3 2z"/>',
      "0 0 16 16"
    )
    EXTERNAL_LINK_ICON = _make_icon(
      '<path stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" d="M9 3h4v4M13 3L7 9"/><path stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" d="M6 4H4a1 1 0 00-1 1v7a1 1 0 001 1h7a1 1 0 001-1v-2"/>',
      "0 0 16 16"
    )
    EYE_ICON = _make_icon(
      '<path stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" d="M1 8s2.5-5 7-5 7 5 7 5-2.5 5-7 5-7-5-7-5z"/><circle cx="8" cy="8" r="2" stroke="currentColor" stroke-width="1.5"/>',
      "0 0 16 16"
    )
    EYE_OFF_ICON = _make_icon(
      '<path stroke="currentColor" stroke-width="1.5" stroke-linecap="round" d="M2 2l12 12"/><path stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" d="M4 5.3C2.4 6.5 1 8 1 8s2.5 5 7 5c1.4 0 2.7-.4 3.8-1M9 3.3C11.6 4 14.2 6.2 15 8a12 12 0 01-2 2.7"/><path stroke="currentColor" stroke-width="1.5" stroke-linecap="round" d="M9.8 9.8A2 2 0 016.2 6.2"/>',
      "0 0 16 16"
    )
    INFO_CIRCLE_ICON = _make_icon(
      '<circle cx="8" cy="8" r="6" stroke="currentColor" stroke-width="1.5"/><path stroke="currentColor" stroke-width="1" stroke-linecap="round" d="M8 7.5v3.5"/><circle cx="8" cy="5.5" r="0.75" fill="currentColor"/>',
      "0 0 16 16"
    )
    MENU_ICON = _make_icon(
      '<rect y="3" width="20" height="2" rx="1" fill="currentColor"/><rect y="9" width="20" height="2" rx="1" fill="currentColor"/><rect y="15" width="20" height="2" rx="1" fill="currentColor"/>',
      "0 0 20 20"
    )
    PLUS_ICON = _make_icon(
      '<path stroke="currentColor" stroke-width="2" stroke-linecap="round" d="M8 3v10M3 8h10"/>',
      "0 0 16 16"
    )
    SEARCH_ICON = _make_icon(
      '<circle cx="7" cy="7" r="4.5" stroke="currentColor" stroke-width="1.5"/><path stroke="currentColor" stroke-width="1.75" stroke-linecap="round" d="M10.5 10.5L14 14"/>',
      "0 0 16 16"
    )
    TRASH_ICON = _make_icon(
      '<path stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" d="M2 5h12M6 5V4a1 1 0 011-1h2a1 1 0 011 1v1"/><path stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" d="M4.5 5l.7 7.5a1 1 0 001 .9h3.6a1 1 0 001-.9L11.5 5"/>',
      "0 0 16 16"
    )
    USER_ICON = _make_icon(
      '<circle cx="8" cy="6" r="2.5" stroke="currentColor" stroke-width="1.5"/><path stroke="currentColor" stroke-width="1.5" stroke-linecap="round" d="M2.5 14c0-2.8 2.5-5 5.5-5s5.5 2.2 5.5 5"/>',
      "0 0 16 16"
    )
    WARNING_ICON = _make_icon(
      '<path stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="M8 2L1.5 13.5h13L8 2z"/><path stroke="currentColor" stroke-width="1" stroke-linecap="round" d="M8 7v3"/><circle cx="8" cy="12" r="0.75" fill="currentColor"/>',
      "0 0 16 16"
    )

    def check_circle_icon(props = nil) = CHECK_CIRCLE_ICON.call(props)
    def chev_down_icon(props = nil)    = CHEV_DOWN_ICON.call(props)
    def chev_left_icon(props = nil)    = CHEV_LEFT_ICON.call(props)
    def chev_right_icon(props = nil)   = CHEV_RIGHT_ICON.call(props)
    def chev_up_icon(props = nil)      = CHEV_UP_ICON.call(props)
    def close_icon(props = nil)        = CLOSE_ICON.call(props)
    def copy_icon(props = nil)         = COPY_ICON.call(props)
    def danger_circle_icon(props = nil)= DANGER_CIRCLE_ICON.call(props)
    def edit_icon(props = nil)         = EDIT_ICON.call(props)
    def external_link_icon(props = nil)= EXTERNAL_LINK_ICON.call(props)
    def eye_icon(props = nil)          = EYE_ICON.call(props)
    def eye_off_icon(props = nil)      = EYE_OFF_ICON.call(props)
    def info_circle_icon(props = nil)  = INFO_CIRCLE_ICON.call(props)
    def menu_icon(props = nil)         = MENU_ICON.call(props)
    def plus_icon(props = nil)         = PLUS_ICON.call(props)
    def search_icon(props = nil)       = SEARCH_ICON.call(props)
    def trash_icon(props = nil)        = TRASH_ICON.call(props)
    def user_icon(props = nil)         = USER_ICON.call(props)
    def warning_icon(props = nil)      = WARNING_ICON.call(props)
  end
end
