# frozen_string_literal: true

class NewsItem < ApplicationRecord
  belongs_to :representative
  has_many :ratings, dependent: :delete_all

  def self.create_news_item(title, link, desc, _rep_id)
    data = {
      title:       title,
      link:        link,
      description: desc

    }
    NewsItem.find_or_create_by(data)
  end

  def self.find_for(representative_id)
    NewsItem.find_by(
      representative_id: representative_id
    )
  end

  def add_rating(rating)
    self.ratings << rating
  end

  def average_rating()
    news_item_ratings = self.ratings
    average = 0
    if news_item_ratings.any?
      total_ratings = news_item_ratings.sum(&:value)  # Assuming 'value' is the attribute representing the rating
      average = total_ratings.to_f / news_item_ratings.length
    end
    average
  end
end
