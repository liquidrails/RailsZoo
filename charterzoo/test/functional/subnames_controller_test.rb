require File.dirname(__FILE__) + '/../test_helper'

class SubnamesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:subnames)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_subname
    assert_difference('Subname.count') do
      post :create, :subname => { }
    end

    assert_redirected_to subname_path(assigns(:subname))
  end

  def test_should_show_subname
    get :show, :id => subnames(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => subnames(:one).id
    assert_response :success
  end

  def test_should_update_subname
    put :update, :id => subnames(:one).id, :subname => { }
    assert_redirected_to subname_path(assigns(:subname))
  end

  def test_should_destroy_subname
    assert_difference('Subname.count', -1) do
      delete :destroy, :id => subnames(:one).id
    end

    assert_redirected_to subnames_path
  end
end
