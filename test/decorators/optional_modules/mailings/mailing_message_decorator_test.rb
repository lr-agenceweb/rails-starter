# frozen_string_literal: true
require 'test_helper'

#
# MailingMessage Decorator test
# ==============================
class MailingMessageDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  test 'should return correct code for preview method' do
    expected = "<a target=\"_blank\" href=\"/admin/mailing_messages/#{@mailing_message_decorated.id}/preview\">Prévisualisation du mail à envoyer en Français</a><br /><a target=\"_blank\" href=\"/en/admin/mailing_messages/#{@mailing_message_decorated.id}/preview\">Prévisualisation du mail à envoyer en English</a><br />"
    assert_equal expected, @mailing_message_decorated.preview
  end

  test 'should return correct value for sent_at method' do
    assert_equal 'Envoyée le mercredi 09 décembre 2015 à 18h10', @mailing_message_decorated.sent_at
  end

  #
  # Status tag
  # ============
  test 'should return correct status_tag for sent attribute' do
    assert_match '<span class="status_tag envoyé red">Envoyé</span>', @mailing_message_decorated.status
  end

  private

  def initialize_test
    @mailing_message = mailing_messages(:one)
    @mailing_message_decorated = MailingMessageDecorator.new(@mailing_message)
  end
end
