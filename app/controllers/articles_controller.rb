class ArticlesController < ApplicationController
  load_and_authorize_resource

  def index
    @articles = Article.recent.page params[:page]
  end

  def new
    @article = Article.new
  end

  def create
    @article.user = current_user
    if @article.save
      CrawlingJob.perform_async(@article.id)
      redirect_to articles_path
    else
      errors_to_flash(@article)
      render :new
    end
  end

  def edit
  end

  def update
    if @article.update_attributes(article_params)
      CrawlingJob.perform_async(@article.id)
      redirect_to articles_path
    else
      errors_to_flash(@article)
      render :new
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:url, :body)
  end
end
