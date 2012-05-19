class RaceDecorator < ApplicationDecorator
  decorates :race

  def self.options_for_select
    [ Race.all.map(&:category), { :include_blank => true} ]
  end
end