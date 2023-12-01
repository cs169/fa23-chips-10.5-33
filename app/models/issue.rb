# frozen_string_literal: true

class Issue < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  validates :name, presence: true, uniqueness: true
end
