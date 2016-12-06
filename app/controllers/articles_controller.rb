class ArticlesController < ApplicationController
  load_and_authorize_resource

  def index
    @new_article = Article.new
    @articles = Article.recent
  end

  def create
    @article.user = current_user
    if @article.save
      CrawlingJob.perform_async(@article.id)
      redirect_to articles_path
    else
      errors_to_flash(@article)
      index
      render :index
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
