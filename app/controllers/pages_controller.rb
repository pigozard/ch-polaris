class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @poles = Pole.ordered
    @news = News.recent
    @beds_count = Unit.hospitalization.sum(:capacity)
    @ambulatory_places_count = Unit.ambulatory.sum(:capacity)
    @units_count = Unit.count
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
    @poles = Pole.ordered.includes(units: %i[schedules sectors unit_regulation])
    @units_json = @poles.flat_map do |pole|
      pole.units.sort_by { |u| u.position.to_i }.map { |u| u.to_annuaire_json(pole) }
    end.to_json
    @emergency_unit = Unit.find_by(slug: "urgences-psy-polaris")
  end

  def mes_droits
    @users_house = Unit.find_by(unit_type: "users_house")
  end

  def preparer_mon_sejour
    units = Unit.hospitalization.order(:name)
    # { "Parking P1 — accès par l'entrée principale" => [unités…], … }, unités sans parking en dernier
    @parkings = units.group_by(&:parking_info).sort_by { |info, _| info.presence || "~" }
    @all_pmr_accessible = units.all?(&:pmr_accessible?)
    @emergency_unit = Unit.find_by(slug: "urgences-psy-polaris")
  end

  def trouver_mon_cmp
    @postal_code = params[:postal_code].to_s.strip
    audience = params[:audience].presence_in(Unit::AUDIENCE_LABELS.keys)

    if @postal_code.match?(/\A\d{5}\z/)
      @cmps = find_cmps(@postal_code, audience)
      @not_found = @cmps.empty?
    else
      @invalid_format = true
      @cmps = []
    end

    render partial: "pages/cmp_result", layout: false
  end

  private

  def find_cmps(postal_code, audience)
    unit_ids = Sector.where(postal_code: postal_code).pluck(:unit_id)
    cmps = Unit.where(id: unit_ids, unit_type: "cmp").includes(:schedules, :pole)
    audience ? cmps.where(audience: audience) : cmps
  end
end
