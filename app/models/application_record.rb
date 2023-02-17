class ApplicationRecord < ActiveRecord::Base
  include Hashid::Rails

  self.abstract_class = true
end
