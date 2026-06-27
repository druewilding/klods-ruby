module Klods
  module RailsSafety
    def to_s
      super.html_safe
    end

    alias to_str to_s
  end
end
