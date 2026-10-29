class NewsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @news = News.published.includes(:pole)
  end

  def show
    @article = News.published.find_by!(slug: params[:id])
  end
end
