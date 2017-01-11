# frozen_string_literal: false
require 'test_helper'

#
# NewsletterDecorator test
# ==========================
class NewsletterDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # Content
  # =========
  test 'should return correct title' do
    assert_equal 'Première newsletter', @newsletter_decorated.title
  end

  test 'should return correct value for sent_at method' do
    assert_equal 'Envoyée le lundi 08 février 2016 à 13h16', @newsletter_decorated.sent_at
  end

  test 'should return correct value language buttons preview' do
    html = []
    html << safe_join([raw("<a target=\"_blank\" href=\"/admin/newsletters/#{@newsletter.id}/preview\">Français</a><br />")]) if @locales.include?(:fr)
    html << safe_join([raw("<a target=\"_blank\" href=\"/en/admin/newsletters/#{@newsletter.id}/preview\">English</a><br />")]) if @locales.include?(:en)
    html << safe_join([raw("<a target=\"_blank\" href=\"/es/admin/newsletters/#{@newsletter.id}/preview\">Español</a><br />")]) if @locales.include?(:es)
    assert_equal safe_join([html]), @newsletter_decorated.preview
  end

  test 'should return correct value for live preview' do
    assert_equal "<iframe id='newsletter_preview_frame' src='/admin/newsletters/#{@newsletter.id}/preview' onload=\"this.style.height = this.contentWindow.document.body.scrollHeight + 30 + 'px'\"></iframe>", @newsletter_decorated.live_preview
  end

  test 'should return correct value for list_subscribers' do
    assert_equal '<ul><li><a href="mailto:foo@bar.com">foo@bar.com</a></li><li><a href="mailto:newsletteruser@test.fr">newsletteruser@test.fr</a></li><li><a href="mailto:newsletteruser@test.en">newsletteruser@test.en</a></li></ul>', @newsletter_decorated.list_subscribers
  end

  #
  # Status tag
  # ============
  test 'should return correct status_tag if already_sent' do
    assert_match '<span class="status_tag envoyé red">Envoyé</span>', @newsletter_decorated.status
  end

  test 'should return correct status_tag if not already_sent' do
    @newsletter.update_attribute(:sent_at, nil)
    assert_match '<span class="status_tag pas_encore_envoyé green">Pas Encore Envoyé</span>', @newsletter_decorated.status
  end

  test 'should return correct resource name' do
    assert_equal 'newsletter', @newsletter_decorated.send(:resource_name)
    assert_equal 'newsletter', @newsletter_decorated.send(:resource_name, with_gsub: true)
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @newsletter = newsletters(:one)
    @newsletter_decorated = NewsletterDecorator.new(@newsletter)
  end
end
