# frozen_string_literal: true
require 'test_helper'

#
# == LegalNotice model test
#
class LegalNoticeTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # == Validation rules
  #
  test 'should be valid if title filled' do
    legal_notice = LegalNotice.new(id: SecureRandom.random_number(1_000))
    legal_notice.set_translations(
      fr: { title: 'Mon article de Mentions Légales' },
      en: { title: 'My Legal Notice article' }
    )

    assert legal_notice.valid?, 'should be valid if title filled'
    assert_empty legal_notice.errors.keys
  end

  test 'should not be valid if title is not filled' do
    legal_notice = LegalNotice.new {}
    refute legal_notice.valid?, 'should not be valid if title is not set'
    assert_equal [:"translations.title"], legal_notice.errors.keys
  end

  #
  # == Slug
  #
  test 'should be valid if title is set properly' do
    legal_notice = LegalNotice.new(id: SecureRandom.random_number(1_000))
    legal_notice.set_translations(
      fr: { title: 'Mon article de Mentions Légales' },
      en: { title: 'My Legal Notice article' }
    )

    assert legal_notice.valid?, 'should be valid if title is set properly'
    assert_empty legal_notice.errors.keys

    I18n.with_locale('fr') do
      assert_equal 'Mon article de Mentions Légales', legal_notice.title
      assert_equal 'mon-article-de-mentions-legales', legal_notice.slug
    end
    I18n.with_locale('en') do
      assert_equal 'My Legal Notice article', legal_notice.title
      assert_equal 'my-legal-notice-article', legal_notice.slug
    end

    legal_notice.delete
  end

  test 'should add id to slug if slug already exists' do
    legal_notice = LegalNotice.new(id: SecureRandom.random_number(1_000))
    legal_notice.set_translations(
      fr: { title: 'Mes mentions légales' },
      en: { title: 'My legal notices' }
    )

    assert legal_notice.valid?, 'should be valid'
    assert_empty legal_notice.errors.keys
    assert_empty legal_notice.errors.messages

    I18n.with_locale('fr') do
      assert_equal 'mes-mentions-legales-2', legal_notice.slug
    end
    I18n.with_locale('en') do
      assert_equal 'my-legal-notices-2', legal_notice.slug
    end

    legal_notice.delete
  end

  private

  def initialize_test
    @legal_notice = posts(:legal_notice_admin)
  end
end
