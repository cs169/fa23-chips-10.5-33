# frozen_string_literal: true

class Rating < ApplicationRecord
  belongs_to :news_item 
  belongs_to :user
end
