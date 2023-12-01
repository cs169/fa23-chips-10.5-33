# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative
  before_action :set_representatives_list
  before_action :set_issues_list
  before_action :set_news_item, only: %i[edit update destroy]

  def new
    Rails.logger.info('in new')
    @news_item = NewsItem.new
    Rails.logger.info('in new, after making news item')
  end

  def edit; end

  def create
    Rails.logger.info('in create')
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

  # def select_rep_issue
  #   if params[:news_item][:representative_id].present? && params[:news_item][:issue].present?
  #     session[:selected_representative_id] = params[:news_item][:representative_id]
  #     session[:selected_issue] = params[:news_item][:issue]

  #     redirect_to new_rep_issue_my_news_item_path
  #   else
  #     render 'select_rep_and_issue'
  #   end
  # end

  # def select_rep_issue
  #   Rails.logger.info(params)
  #   Rails.logger.info(params[:news_item])
  #   Rails.logger.info(@representative)
  #   Rails.logger.info(@issues_list)
  #   if params[:news_item].present?
  #     session[:selected_representative_id] = params[:news_item][:representative_id]
  #     session[:selected_issue] = params[:news_item][:issue]

  #     redirect_to representative_top_articles_my_news_item_path(
  #       @representative,
  #       representative_id: session[:selected_representative_id],
  #       issue: session[:selected_issue]
  #     )
  #   else
  #     render :select_rep_issue
  #   end
  # end

  def search
    @news_item = NewsItem.new(news_item_params)
    if params[:news_item].present? && params[:news_item][:representative_id].present? &&
       params[:news_item][:issue].present?
      session[:selected_representative_id] = params[:news_item][:representative_id]
      session[:selected_issue] = params[:news_item][:issue]

      redirect_to representative_top_articles_path(
        @representative,
        representative_id: session[:selected_representative_id],
        issue:             session[:selected_issue]
      )
    else
      render :new, error: 'An error occurred when creating the news item.'
    end
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
    Rails.logger.info(@top_articles)
    @top_articles.each do |article|
      Rails.logger.info(article)
      Rails.logger.info(article.instance_variable_get(:@title))
    end
  end

  def rate_article
    Rails.logger.info('in rate article (new!)')
    Rails.logger.info(session[:selected_rep])
    Rails.logger.info(session[:selected_issue])
    Rails.logger.info(@representative)
    @news_item = NewsItem.find_or_create_by(
      {
        title:             params[:selected_article][:title],
        link:              params[:selected_article][:url],
        description:       params[:selected_article][:description],
        issue:             session[:selected_issue],
        representative_id: @representative.id
      }
    )
    new_rating = Rating.create(user: @current_user, news_item: @news_item, value: params[:ratings][:rating])
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

  def selected_article_params
    params.require(:selected_article).permit(:title, :description, :link, :representative_id, :issue) # added issue
  end
end
