require 'test_helper'

class FlagsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:flags)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_flag
    assert_difference('Flag.count') do
      post :create, :flag => { }
    end

    assert_redirected_to flag_path(assigns(:flag))
  end

  def test_should_show_flag
    get :show, :id => flags(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => flags(:one).id
    assert_response :success
  end

  def test_should_update_flag
    put :update, :id => flags(:one).id, :flag => { }
    assert_redirected_to flag_path(assigns(:flag))
  end

  def test_should_destroy_flag
    assert_difference('Flag.count', -1) do
      delete :destroy, :id => flags(:one).id
    end

    assert_redirected_to flags_path
  end
end
