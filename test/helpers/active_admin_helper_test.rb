require 'test_helper'

#
# == ActiveAdmin namespace
#
module ActiveAdmin
  #
  # == ActiveAdminHelper Test
  #
  class ActiveAdminHelperTest < ActionView::TestCase
    include Rails.application.routes.url_helpers

    setup :initialize_test

    test 'should return correct edit page title' do
      @controller = ContactsController.new
      @controller.request = ActionController::TestRequest.new(host: 'http://test.host')
      assert_equal "<a href=\"/admin/categories/#{@category_contact.id}/edit\">Modifier l'entête de la page #{@category_contact.menu_title}</a>", edit_heading_page_aa
    end

    private

    def initialize_test
      @category_contact = categories(:contact)
    end
  end
end
