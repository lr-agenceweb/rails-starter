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

    test 'should return correct edit heading action_item link' do
      @controller = ContactsController.new
      @controller.request = ActionController::TestRequest.new(host: 'http://test.host')
      expected = "<a target=\"_blank\" href=\"/admin/categories/#{@category_contact.id}/edit?section=heading#heading\">#{I18n.t('active_admin.action_item.edit_heading', page: 'Contact')}</a>"
      assert_equal expected, action_item_page
    end

    test 'should return correct edit referencement action_item link' do
      @controller = HomesController.new
      @controller.request = ActionController::TestRequest.new(host: 'http://test.host')
      expected = "<a target=\"_blank\" href=\"/admin/categories/#{@category_home.id}/edit?section=referencement#referencement\">#{I18n.t('active_admin.action_item.edit_referencement', page: 'Accueil')}</a>"
      assert_equal expected, action_item_page('', 'referencement')
    end

    private

    def initialize_test
      @category_contact = categories(:contact)
      @category_home = categories(:home)
    end
  end
end
