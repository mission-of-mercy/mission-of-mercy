class Race < ActiveRecord::Base
  validates_presence_of :category

  def self.all_categories
    all.map(&:category)
  end
end
