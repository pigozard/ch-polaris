require "test_helper"

# Pages de lecture : espacements resserrés partagés (classe .page-reading dans polaris.css)
class ReadingPagesTest < ActionDispatch::IntegrationTest
  test "les pages de lecture utilisent la mise en page resserrée" do
    [preparer_mon_sejour_path, mes_droits_path, tools_path, cardiac_coherence_tool_path].each do |path|
      get path
      assert_select "main .container.page-reading", 1, "mise en page de lecture absente sur #{path}"
    end
  end
end
