# frozen_string_literal: true

class NewsItem < ApplicationRecord
  belongs_to :representative
  has_many :ratings, dependent: :delete_all

  def self.find_for(representative_id)
    NewsItem.find_by(
      representative_id: representative_id
    )
  end

  def update_average
    total = 0
    ratings.each do |rating|
      total += rating.value
    end
    avg = total / ratings.length
    self[:average] = avg.round(1)
  end
end
