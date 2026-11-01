require "test_helper"

# Aucun compte n'est utilisé pour l'instant : l'inscription publique est fermée
class RegistrationClosedTest < ActionDispatch::IntegrationTest
  test "la page d'inscription n'existe pas" do
    get "/users/sign_up"
    assert_response :not_found
  end

  test "la page de connexion ne propose pas de s'inscrire" do
    get new_user_session_path
    assert_response :success
    assert_select "a[href='/users/sign_up']", 0
  end
end
