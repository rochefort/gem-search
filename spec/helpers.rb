require "helpers/dummy_data"

module Helpers
  def self.included(_base)
    include DummyData
  end
end
