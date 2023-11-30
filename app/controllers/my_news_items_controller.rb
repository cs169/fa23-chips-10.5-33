# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative
  before_action :set_representatives_list
  before_action :set_issues_list
  before_action :set_news_item, only: %i[edit update destroy]

  def new
    Rails.logger.info("in new")
    @news_item = NewsItem.new
    Rails.logger.info("in new, after making news item")
  end

  def edit; end

  def create
    Rails.logger.info("in create")
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
    Rails.logger.info("in search")
    Rails.logger.info(params)
    Rails.logger.info(params[:news_item])
    Rails.logger.info(@representative)
    Rails.logger.info(@issues_list)
    @news_item = NewsItem.new(news_item_params)
    if params[:news_item].present? and params[:news_item][:representative_id].present? and
       params[:news_item][:issue].present?
      session[:selected_representative_id] = params[:news_item][:representative_id]
      session[:selected_issue] = params[:news_item][:issue]
      Rails.logger.info("in search if statement, about to redirect")

      redirect_to representative_top_articles_path(
        @representative,
        representative_id: session[:selected_representative_id],
        issue: session[:selected_issue]
      )
    else
      render :new, error: 'An error occurred when creating the news item.'
    end
  end


  def top_articles
    Rails.logger.info("in top articles")
    @selected_representative = @representative
    @selected_issue = params[:issue]
    session[:selected_rep] = @selected_representative
    session[:selected_issue] = @selected_issue
    @rating_list = [1, 2, 3, 4, 5]
    newsapi = News.new(Rails.application.credentials[:NEWS_API_KEY])             

    @top_articles = newsapi.get_everything(q: "#{@selected_representative.name} AND #{@selected_issue}",
                                          language: 'en',
                                          sortBy: 'relevancy',
                                          page: 1,
                                          pagesize: 5)
    Rails.logger.info(@top_articles)
    @top_articles.each do |article|
      Rails.logger.info(article)
      # Rails.logger.info(JSON.parse(article))
      Rails.logger.info(article.instance_variable_get(:@title))
    end
  end

  def rate_article
    Rails.logger.info("in rate article (new!)")
    Rails.logger.info(session[:selected_rep])
    Rails.logger.info(session[:selected_issue])
    Rails.logger.info(@representative)
    @news_item = NewsItem.new(
      #representative_id: params[:representative_id],
      title: params[:selected_article][:title],
      link: params[:selected_article][:url],
      description: params[:selected_article][:description],
      rating: params[:ratings][:rating],
      issue: session[:selected_issue],
      representative: @representative 
    )
    Rails.logger.info(@news_item)
    if @news_item.save
      NewsItem.all.each do |news|
        Rails.logger.info("PRINTING NEW NEWS ARTICLE")
        Rails.logger.info(news)
        Rails.logger.info(news.title)
        Rails.logger.info(news.link)
        Rails.logger.info(news.description)
        Rails.logger.info(news.rating)
        Rails.logger.info(news.representative_id)
        Rails.logger.info(news.created_at)
      end
      redirect_to representative_news_items_path(@representative)
    else
      render :new, error: 'An error occurred when creating the news item.'
    end
  end

  # def new_rep_issue
  #   @selected_representative_id = session[:selected_representative_id]
  #   @selected_issue = session[:selected_issue]
  #   @selected_article = params[:news_item][:selected_article] # Update this with the actual parameter name

  #   # Additional logic to fetch details of the selected article (replace this with your actual logic)

  #   # Render the view with the article details and the form for saving
  # end

  
  private

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
    params.require(:news_item).permit(:title, :description, :link, :representative_id, :issue, :rating) #added issue
  end

  def selected_article_params
    params.require(:selected_article).permit(:title, :description, :link, :representative_id, :issue, :rating) #added issue
  end

end
