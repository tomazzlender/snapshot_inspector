module Minitest
  module Snapshot
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
