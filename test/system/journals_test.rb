require "application_system_test_case"

class JournalsTest < ApplicationSystemTestCase
  setup do
    @journal = journals(:one)
  end

  test "visiting the index" do
    visit journals_url
    assert_selector "h1", text: "Journals"
  end

  test "should create journal" do
    visit journals_url
    click_on "New journal"

    check "Active" if @journal.active
    check "Balanced" if @journal.balanced
    fill_in "Currency", with: @journal.currency
    fill_in "Date", with: @journal.date
    fill_in "Description", with: @journal.description
    fill_in "Trans nat", with: @journal.trans_nat
    click_on "Create Journal"

    assert_text "Journal was successfully created"
    click_on "Back"
  end

  test "should update Journal" do
    visit journal_url(@journal)
    click_on "Edit this journal", match: :first

    check "Active" if @journal.active
    check "Balanced" if @journal.balanced
    fill_in "Currency", with: @journal.currency
    fill_in "Date", with: @journal.date
    fill_in "Description", with: @journal.description
    fill_in "Trans nat", with: @journal.trans_nat
    click_on "Update Journal"

    assert_text "Journal was successfully updated"
    click_on "Back"
  end

  test "should destroy Journal" do
    visit journal_url(@journal)
    click_on "Destroy this journal", match: :first

    assert_text "Journal was successfully destroyed"
  end
end
