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
    assert_equal [:'translations.name', :'translations.slug'], blog_category.errors.keys
  end

  test 'should not be valid if name is empty' do
    blog_category = BlogCategory.new(id: SecureRandom.uuid)
    blog_category.set_translations(
      fr: { name: '' },
      en: { name: '' }
    )
    refute blog_category.valid?, 'should not be valid if name is empty'
    assert_equal [:'translations.name', :'translations.slug'], blog_category.errors.keys
  end

  test 'should not be valid if name is already taken' do
    blog_category = BlogCategory.new(id: SecureRandom.uuid)
    blog_category.set_translations(
      fr: { name: 'foo', slug: 'foo' },
      en: { name: 'bar', slug: 'bar' }
    )
    refute blog_category.valid?, 'should not be valid if name is already taken'
    assert_equal [:'translations.name', :'translations.slug'], blog_category.errors.keys
  end

  test 'should be valid if name is set properly but same for both locales' do
    skip 'Find a way to test not conflict uniqueness for a same record translations'
    blog_category = BlogCategory.new(id: SecureRandom.uuid)
    blog_category.set_translations(
      fr: { name: 'Foo Foo', slug: 'foofoo' },
      en: { name: 'Foo Foo', slug: 'foofoo' }
    )

    assert blog_category.valid?, 'should be valid if name is set properly but same for both locales'
    assert_empty blog_category.errors.keys

    I18n.with_locale('fr') do
      assert_equal 'Foo Foo', blog_category.name
      assert_equal 'foofoo', blog_category.slug
    end
    I18n.with_locale('en') do
      assert_equal 'Foo Foo', blog_category.name
      assert_equal 'foofoo', blog_category.slug
    end
  end

  test 'should be valid if name is set properly' do
    blog_category = BlogCategory.new(id: SecureRandom.uuid)
    blog_category.set_translations(
      fr: { name: 'Foo Foo', slug: 'foofoo' },
      en: { name: 'Bar Bar', slug: 'barbar' }
    )

    assert blog_category.valid?, 'should be valid if name is set properly'
    assert_empty blog_category.errors.keys

    I18n.with_locale('fr') do
      assert_equal 'Foo Foo', blog_category.name
      assert_equal 'foofoo', blog_category.slug
    end
    I18n.with_locale('en') do
      assert_equal 'Bar Bar', blog_category.name
      assert_equal 'barbar', blog_category.slug
    end
  end
end
