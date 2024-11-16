require "test_helper"

class RoadConditionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get road_conditions_new_url
    assert_response :success
  end
end
