require "application_system_test_case"

class ParamsTest < ApplicationSystemTestCase
  setup do
    @param = params(:one)
  end

  test "visiting the index" do
    visit params_url
    assert_selector "h1", text: "Params"
  end

  test "should create param" do
    visit params_url
    click_on "New param"

    check "Active" if @param.active
    fill_in "Group", with: @param.group
    fill_in "Label", with: @param.label
    fill_in "Value", with: @param.value
    click_on "Create Param"

    assert_text "Param was successfully created"
    click_on "Back"
  end

  test "should update Param" do
    visit param_url(@param)
    click_on "Edit this param", match: :first

    check "Active" if @param.active
    fill_in "Group", with: @param.group
    fill_in "Label", with: @param.label
    fill_in "Value", with: @param.value
    click_on "Update Param"

    assert_text "Param was successfully updated"
    click_on "Back"
  end

  test "should destroy Param" do
    visit param_url(@param)
    click_on "Destroy this param", match: :first

    assert_text "Param was successfully destroyed"
  end
end
