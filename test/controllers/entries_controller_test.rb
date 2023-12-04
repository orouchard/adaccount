require "test_helper"

class EntriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get entries_new_url
    assert_response :success
  end

  test "should get edit" do
    get entries_edit_url
    assert_response :success
  end

  test "should get delete" do
    get entries_delete_url
    assert_response :success
  end
end
