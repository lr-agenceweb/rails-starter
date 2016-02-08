require 'test_helper'

#
# == MailingMessageDecorator test
#
class MailingMessageDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  test 'should return correct value for sent_at method' do
    assert_equal 'Envoyée le mercredi 09 décembre 2015 à 18h10', @mailing_message_decorated.sent_at_message
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag for sent attribute' do
    assert_match "<span class=\"status_tag envoyé red\">Envoyé</span>", @mailing_message_decorated.status
  end

  private

  def initialize_test
    @mailing_message = mailing_messages(:one)
    @mailing_message_decorated = MailingMessageDecorator.new(@mailing_message)
  end
end
