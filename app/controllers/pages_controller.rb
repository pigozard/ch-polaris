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

  def hopital
    @poles = Pole.ordered.includes(:units)
    @news  = News.recent.includes(:pole)
  end

  def carte
    @poles = Pole.ordered.includes(:units)
  end
end
