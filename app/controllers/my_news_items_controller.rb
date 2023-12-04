# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative
  before_action :set_representatives_list
  before_action :set_issues_list
  before_action :set_news_item, only: %i[edit update destroy]

  def new
    @news_item = NewsItem.new
  end

  def edit; end

  def create
    @news_item = NewsItem.new(news_item_params)
    if @news_item.save
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully created.'
    else
      render :new, error: 'An error occurred when creating the news item.'
    end
  end

  def update
    if @news_item.update(news_item_params)
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully updated.'
    else
      render :edit, error: 'An error occurred when updating the news item.'
    end
  end

  def destroy
    @news_item.destroy
    redirect_to representative_news_items_path(@representative),
                notice: 'News was successfully destroyed.'
  end

  def search
    @news_item = NewsItem.new(news_item_params)
    if params[:news_item].present? && params[:news_item][:representative_id].present? &&
       params[:news_item][:issue].present?
      set_rep_and_issue
      redirect_to representative_top_articles_path(
        @representative,
        representative_id: session[:selected_representative_id],
        issue:             session[:selected_issue]
      )
    else
      render :new, error: 'An error occurred when creating the news item.'
    end
  end

  def set_rep_and_issue
    session[:selected_representative_id] = params[:news_item][:representative_id]
    session[:selected_issue] = params[:news_item][:issue]
  end

  def top_articles
    @selected_representative = @representative
    @selected_issue = params[:issue]
    session[:selected_rep] = @selected_representative
    session[:selected_issue] = @selected_issue
    @rating_list = [1, 2, 3, 4, 5]
    newsapi = News.new(Rails.application.credentials[:NEWS_API_KEY])

    @top_articles = newsapi.get_everything(q:        "#{@selected_representative.name} AND #{@selected_issue}",
                                           language: 'en',
                                           sortBy:   'relevancy',
                                           page:     1,
                                           pagesize: 5)
  end

  def rate_article
    @id = params[:selected_article][:article_id]
    @news_item = NewsItem.find_or_create_by(
      {
        title:             params[:selected_article][:title][@id],
        link:              params[:selected_article][:url][@id],
        description:       params[:selected_article][:description][@id],
        issue:             session[:selected_issue],
        representative_id: @representative.id
      }
    )
    Rating.create(user: @current_user, news_item: @news_item, value: params[:ratings][:rating])
    @news_item.update_average

    if @news_item.save
      redirect_to representative_news_items_path(@representative)
    else
      render :new, error: 'An error occurred when creating the news item.'
    end
  end

  def set_representative
    @representative = Representative.find(
      params[:representative_id]
    )
  end

  def set_representatives_list
    @representatives_list = Representative.all.map { |r| [r.name, r.id] }
  end

  def set_news_item
    @news_item = NewsItem.find(params[:id])
  end

  def set_issues_list
    @issues_list = ['Free Speech', 'Immigration', 'Terrorism', 'Social Security and
    Medicare', 'Abortion', 'Student Loans', 'Gun Control', 'Unemployment', 'Climate
     Change', 'Homelessness', 'Racism', 'Tax Reform', 'Net Neutrality', 'Religious
     Freedom', 'Border Security', 'Minimum Wage', 'Equal Pay']
  end

  # Only allow a list of trusted parameters through.
  def news_item_params
    params.require(:news_item).permit(:title, :description, :link, :representative_id, :issue) # added issue
  end
end
