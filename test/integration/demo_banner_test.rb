require "test_helper"

class DemoBannerTest < ActionDispatch::IntegrationTest
  BANNER = "Site fictif de démonstration".freeze

  test "le bandeau de démonstration apparaît sur toutes les pages publiques" do
    [root_path, patients_path, professionnels_path, mes_droits_path,
     etp_programs_path, news_index_path, tools_path, cardiac_coherence_tool_path].each do |path|
      get path
      assert_select ".demo-banner", { text: /#{BANNER}/ }, "bandeau absent sur #{path}"
    end
  end

  test "le bandeau précise que le site ne délivre ni soin ni conseil médical" do
    get root_path
    assert_select ".demo-banner", /ne délivre aucun soin ni conseil médical/
  end
end
