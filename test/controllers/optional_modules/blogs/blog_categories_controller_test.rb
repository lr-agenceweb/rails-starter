# frozen_string_literal: true
require 'test_helper'

#
# == BlogCategoriesController Test
#
class BlogCategoriesControllerTest < ActionController::TestCase
  test 'should get show' do
    get :show
    assert_response :success
  end
end
