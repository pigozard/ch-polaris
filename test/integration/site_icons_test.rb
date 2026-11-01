require "test_helper"

class SiteIconsTest < ActionDispatch::IntegrationTest
  test "le logo de la barre de navigation est léger" do
    assert_operator Rails.root.join("app/assets/images/logo-polaris.png").size, :<, 50.kilobytes
  end

  test "le favicon et l'icône iPhone ne sont pas vides" do
    %w[favicon.ico apple-touch-icon.png apple-touch-icon-precomposed.png].each do |file|
      assert_operator Rails.root.join("public", file).size, :>, 0, "#{file} est vide"
    end
  end

  test "chaque page déclare son favicon et son icône iPhone" do
    get root_path
    assert_select "link[rel=icon][href='/favicon.ico']"
    assert_select "link[rel=apple-touch-icon][href='/apple-touch-icon.png']"
  end
end
