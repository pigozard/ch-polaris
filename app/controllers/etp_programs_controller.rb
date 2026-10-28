class EtpProgramsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_utep

  def index
    @pathology = params[:pathology].presence_in(EtpProgram::PATHOLOGIES)
    @pathologies = EtpProgram.distinct.pluck(:pathology)
    @etp_programs = EtpProgram.order(:name)
    @etp_programs = @etp_programs.where(pathology: @pathology) if @pathology
  end

  def show
    @etp_program = EtpProgram.find(params[:id])
    @etp_sessions = @etp_program.etp_sessions.order(:starts_on)
  end

  private

  def set_utep
    @utep = Unit.find_by(unit_type: "utep")
  end
end
