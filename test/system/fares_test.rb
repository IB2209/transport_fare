require "application_system_test_case"

class FaresTest < ApplicationSystemTestCase
  setup do
    @fare = fares(:one)
  end

  test "visiting the index" do
    visit fares_url
    assert_selector "h1", text: "Fares"
  end

  test "should create fare" do
    visit fares_url
    click_on "New fare"

    fill_in "Arrival", with: @fare.arrival
    fill_in "Departure", with: @fare.departure
    fill_in "Distance", with: @fare.distance
    fill_in "Fare large", with: @fare.fare_large
    fill_in "Fare medium", with: @fare.fare_medium
    fill_in "Fare small", with: @fare.fare_small
    click_on "Create Fare"

    assert_text "Fare was successfully created"
    click_on "Back"
  end

  test "should update Fare" do
    visit fare_url(@fare)
    click_on "Edit this fare", match: :first

    fill_in "Arrival", with: @fare.arrival
    fill_in "Departure", with: @fare.departure
    fill_in "Distance", with: @fare.distance
    fill_in "Fare large", with: @fare.fare_large
    fill_in "Fare medium", with: @fare.fare_medium
    fill_in "Fare small", with: @fare.fare_small
    click_on "Update Fare"

    assert_text "Fare was successfully updated"
    click_on "Back"
  end

  test "should destroy Fare" do
    visit fare_url(@fare)
    click_on "Destroy this fare", match: :first

    assert_text "Fare was successfully destroyed"
  end
end
