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
    @poles = Pole.includes(:units).order(:position)
  end

  def annuaire
    @poles = Pole.ordered.includes(units: [:schedules, :sectors, :unit_regulation])
    @units_json = @poles.flat_map { |pole|
      pole.units.sort_by { |u| u.position.to_i }.map { |u| u.to_annuaire_json(pole) }
    }.to_json
  end

  def trouver_mon_cmp
    @postal_code = params[:postal_code].to_s.strip

    if @postal_code.match?(/\A\d{5}\z/)
      unit_ids = Sector.where(postal_code: @postal_code).pluck(:unit_id)
      @cmps = Unit.where(id: unit_ids, unit_type: "cmp").includes(:schedules, :pole)
      @not_found = @cmps.empty?
    else
      @invalid_format = true
      @cmps = []
    end

    render partial: "pages/cmp_result", layout: false
  end
end
