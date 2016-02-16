require 'helpers/dummy_data'

module Helpers
  def self.included(_base)
    include Dummy_data
  end
end
