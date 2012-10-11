require 'test_helper'

class EtsySalesAggregatesControllerTest < ActionController::TestCase
  setup do
    @etsy_sales_aggregate = etsy_sales_aggregates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:etsy_sales_aggregates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create etsy_sales_aggregate" do
    assert_difference('EtsySalesAggregate.count') do
      post :create, etsy_sales_aggregate: { aggregate: @etsy_sales_aggregate.aggregate, city: @etsy_sales_aggregate.city, country_id: @etsy_sales_aggregate.country_id, country_name: @etsy_sales_aggregate.country_name, quantity: @etsy_sales_aggregate.quantity, state: @etsy_sales_aggregate.state, value: @etsy_sales_aggregate.value, zip: @etsy_sales_aggregate.zip }
    end

    assert_redirected_to etsy_sales_aggregate_path(assigns(:etsy_sales_aggregate))
  end

  test "should show etsy_sales_aggregate" do
    get :show, id: @etsy_sales_aggregate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @etsy_sales_aggregate
    assert_response :success
  end

  test "should update etsy_sales_aggregate" do
    put :update, id: @etsy_sales_aggregate, etsy_sales_aggregate: { aggregate: @etsy_sales_aggregate.aggregate, city: @etsy_sales_aggregate.city, country_id: @etsy_sales_aggregate.country_id, country_name: @etsy_sales_aggregate.country_name, quantity: @etsy_sales_aggregate.quantity, state: @etsy_sales_aggregate.state, value: @etsy_sales_aggregate.value, zip: @etsy_sales_aggregate.zip }
    assert_redirected_to etsy_sales_aggregate_path(assigns(:etsy_sales_aggregate))
  end

  test "should destroy etsy_sales_aggregate" do
    assert_difference('EtsySalesAggregate.count', -1) do
      delete :destroy, id: @etsy_sales_aggregate
    end

    assert_redirected_to etsy_sales_aggregates_path
  end
end
