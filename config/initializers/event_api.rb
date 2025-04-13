# frozen_string_literal: true

require 'barong/event_api'

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.include Barong::EventAPI::ActiveRecord::Extension
end
