# frozen_string_literal: true

class NewsItem < ApplicationRecord
  belongs_to :representative
  has_many :ratings, dependent: :delete_all

  def self.create_news_item(title, link, desc, rep_id)
    data = {
      title: title,
      link: link,
      description: desc
      
    }
    NewsItem.find_or_create_by(data)
  end

  def self.find_for(representative_id)
    NewsItem.find_by(
      representative_id: representative_id
    )
  end
end
