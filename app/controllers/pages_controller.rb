class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @poles = Pole.ordered
    @news = News.recent
  end

  def patients
  end

  def professionnels
  end
end
