module Klods
  class Railtie < Rails::Railtie
    initializer "klods.include_helpers" do
      ActiveSupport.on_load(:action_view) do
        include Klods::Builders
        Klods::Node.prepend(Klods::RailsSafety)
      end
    end
  end
end
