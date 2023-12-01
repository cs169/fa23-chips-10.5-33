# frozen_string_literal: true

class AddRatingToNewsItems < ActiveRecord::Migration[5.2]
  def change
    add_column :news_items, :average, :float
  end
end
