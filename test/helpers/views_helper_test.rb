# frozen_string_literal: true
require 'test_helper'

#
# == ActiveAdmin namespace
#
module ActiveAdmin
  #
  # == ViewsHelper Test
  #
  class ViewsHelperTest < ActionView::TestCase
    include Rails.application.routes.url_helpers

    setup :initialize_test

    test 'should return correct edit page title' do
      @controller = ContactsController.new
      @controller.request = ActionController::TestRequest.new(host: 'http://test.host')
      expected = "<a target=\"_blank\" href=\"/admin/categories/#{@category_contact.id}/edit?section=heading#heading\">#{I18n.t('active_admin.action_item.edit_heading_page', page: 'Contact')}</a>"
      assert_equal expected, action_item_page
    end

    private

    def initialize_test
      @category_contact = categories(:contact)
    end
  end
end
