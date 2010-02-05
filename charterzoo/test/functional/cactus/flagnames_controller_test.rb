require 'test_helper'

class Cactus::FlagnamesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:cactus_flagnames)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_flagname
    assert_difference('Cactus::Flagname.count') do
      post :create, :flagname => { }
    end

    assert_redirected_to flagname_path(assigns(:flagname))
  end

  def test_should_show_flagname
    get :show, :id => cactus_flagnames(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => cactus_flagnames(:one).id
    assert_response :success
  end

  def test_should_update_flagname
    put :update, :id => cactus_flagnames(:one).id, :flagname => { }
    assert_redirected_to flagname_path(assigns(:flagname))
  end

  def test_should_destroy_flagname
    assert_difference('Cactus::Flagname.count', -1) do
      delete :destroy, :id => cactus_flagnames(:one).id
    end

    assert_redirected_to cactus_flagnames_path
  end
end
