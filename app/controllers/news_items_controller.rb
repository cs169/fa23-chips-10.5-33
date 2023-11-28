# frozen_string_literal: true

class NewsItemsController < ApplicationController
  before_action :set_representative
  before_action :set_news_item, only: %i[show]

  def index
    @news_items = @representative.news_items
    Rails.logger.info(@news_items)
    Rails.logger.info(@representative)
    Rails.logger.info(@news_items)
    Rails.logger.info(params[:id])
    Rails.logger.info(params[:representative_id])
  end

  def show; end

  private

  def set_representative
    @representative = Representative.find(
      params[:representative_id]
    )
  end

  def set_news_item
    @news_item = NewsItem.find(params[:id])
  end
end
