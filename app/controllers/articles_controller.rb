# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show destroy]

  def index
    @articles = Article.desc(:created_at).page(page).per(per)

    paginate @articles
  end

  def create
    @article = Article.new article_params
    @article.save!

    render :show
  end

  def show; end

  def destroy
    @article.destroy
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content, :author, :summary)
  end
end
