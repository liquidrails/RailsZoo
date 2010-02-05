require File.dirname(__FILE__) + '/../test_helper'

class SubcategoriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:subcategories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_subcategory
    assert_difference('Subcategory.count') do
      post :create, :subcategory => { }
    end

    assert_redirected_to subcategory_path(assigns(:subcategory))
  end

  def test_should_show_subcategory
    get :show, :id => subcategories(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => subcategories(:one).id
    assert_response :success
  end

  def test_should_update_subcategory
    put :update, :id => subcategories(:one).id, :subcategory => { }
    assert_redirected_to subcategory_path(assigns(:subcategory))
  end

  def test_should_destroy_subcategory
    assert_difference('Subcategory.count', -1) do
      delete :destroy, :id => subcategories(:one).id
    end

    assert_redirected_to subcategories_path
  end
end
