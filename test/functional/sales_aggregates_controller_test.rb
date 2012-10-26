require 'test_helper'

class SalesAggregatesControllerTest < ActionController::TestCase
  setup do
    @sales_aggregate = sales_aggregates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales_aggregates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sales_aggregate" do
    assert_difference('SalesAggregate.count') do
      post :create, sales_aggregate: {  }
    end

    assert_redirected_to sales_aggregate_path(assigns(:sales_aggregate))
  end

  test "should show sales_aggregate" do
    get :show, id: @sales_aggregate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sales_aggregate
    assert_response :success
  end

  test "should update sales_aggregate" do
    put :update, id: @sales_aggregate, sales_aggregate: {  }
    assert_redirected_to sales_aggregate_path(assigns(:sales_aggregate))
  end

  test "should destroy sales_aggregate" do
    assert_difference('SalesAggregate.count', -1) do
      delete :destroy, id: @sales_aggregate
    end

    assert_redirected_to sales_aggregates_path
  end
end
