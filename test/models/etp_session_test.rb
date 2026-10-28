require "test_helper"

class EtpSessionTest < ActiveSupport::TestCase
  test "remaining_places soustrait les inscrits du maximum" do
    session = EtpSession.new(max_participants: 8, current_participants: 6)
    assert_equal 2, session.remaining_places
  end

  test "remaining_places ne descend pas sous zéro" do
    session = EtpSession.new(max_participants: 8, current_participants: 10)
    assert_equal 0, session.remaining_places
  end

  test "remaining_places est nil sans maximum défini" do
    session = EtpSession.new(max_participants: nil)
    assert_nil session.remaining_places
  end

  test "status_label traduit le statut" do
    assert_equal "Complet", EtpSession.new(status: "full").status_label
  end
end
