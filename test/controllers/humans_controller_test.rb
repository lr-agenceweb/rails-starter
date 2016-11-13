# frozen_string_literal: true
require 'test_helper'

#
# == HumansController Test
#
class HumansControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index, params: { format: :txt }
    assert_response :success
  end

  test 'should get index template' do
    get :index, params: { format: :txt }
    assert_template :index
  end
end
