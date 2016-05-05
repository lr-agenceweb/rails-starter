# frozen_string_literal: true
require 'test_helper'

#
# == BlogCategory test
#
class BlogCategoryTest < ActiveSupport::TestCase
  #
  # == Validation rules
  #
  test 'should not be valid if name is not set' do
    blog_category = BlogCategory.new(id: SecureRandom.uuid)
    blog_category.set_translations(
      fr: {},
      en: {}
    )
    refute blog_category.valid?, 'should not be valid if name is not set'
    assert_equal [:'translations.name'], blog_category.errors.keys
  end

  test 'should not be valid if name is empty' do
    blog_category = BlogCategory.new(id: SecureRandom.uuid)
    blog_category.set_translations(
      fr: { name: '' },
      en: { name: '' }
    )
    refute blog_category.valid?, 'should not be valid if name is empty'
    assert_equal [:'translations.name'], blog_category.errors.keys
  end

  test 'should not be valid if name is already taken' do
    blog_category = BlogCategory.new(id: SecureRandom.uuid)
    blog_category.set_translations(
      fr: { name: 'foo' },
      en: { name: 'bar' }
    )
    refute blog_category.valid?, 'should not be valid if name is already taken'
    assert_equal [:'translations.name'], blog_category.errors.keys
  end

  test 'should be valid if name is set properly' do
    blog_category = BlogCategory.new(id: SecureRandom.uuid)
    blog_category.set_translations(
      fr: { name: 'foofoo' },
      en: { name: 'barbar' }
    )

    assert blog_category.valid?, 'should be valid if name is set properly'
    assert_empty blog_category.errors.keys

    I18n.with_locale('fr') { assert_equal 'foofoo', blog_category.name }
    I18n.with_locale('en') { assert_equal 'barbar', blog_category.name }
  end
end
