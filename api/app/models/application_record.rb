class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.convert_ms_to_datetime(ms)
    Time.at(ms/1000)
  end
end
