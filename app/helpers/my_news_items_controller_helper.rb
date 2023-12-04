# frozen_string_literal: true

module MyNewsItemsControllerHelper
  def self.set_rep_and_issue
    session[:selected_representative_id] = params[:news_item][:representative_id]
    session[:selected_issue] = params[:news_item][:issue]
  end
end
