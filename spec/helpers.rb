require 'helpers/dummy_data'

module Helpers
  def self.included(base)
    base.include Dummy_data
  end
end
