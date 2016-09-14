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
    blog_category = BlogCategory.new(id: SecureRandom.random_number(1_000))
    blog_category.set_translations(
      fr: {},
      en: {}
    )
    refute blog_category.valid?, 'should not be valid if name is not set'
    assert_equal [:'translations.name'], blog_category.errors.keys
  end

  test 'should not be valid if name is empty' do
    blog_category = BlogCategory.new(id: SecureRandom.random_number(1_000))
    blog_category.set_translations(
      fr: { name: '' },
      en: { name: '' }
    )
    refute blog_category.valid?, 'should not be valid if name is empty'
    assert_equal [:'translations.name'], blog_category.errors.keys
  end

  test 'should be valid if name is set properly but same for both locales' do
    blog_category = BlogCategory.new(id: SecureRandom.random_number(1_000))
    blog_category.set_translations(
      fr: { name: 'Foo Foo' },
      en: { name: 'Foo Foo' }
    )

    assert blog_category.valid?, 'should be valid if name is set properly but same for both locales'
    assert_empty blog_category.errors.keys

    I18n.with_locale('fr') do
      assert_equal 'Foo Foo', blog_category.name
      assert_equal 'foo-foo', blog_category.slug
    end
    I18n.with_locale('en') do
      assert_equal 'Foo Foo', blog_category.name
      assert_equal 'foo-foo', blog_category.slug
    end
  end

  test 'should add id to slug if slug already exists' do
    blog_category = BlogCategory.new(id: SecureRandom.random_number(1_000))
    blog_category.set_translations(
      fr: { name: 'Foo' },
      en: { name: 'Bar' }
    )

    assert blog_category.valid?, 'should be valid'
    assert_empty blog_category.errors.keys
    assert_empty blog_category.errors.messages

    I18n.with_locale('fr') do
      assert_equal 'foo-2', blog_category.slug
    end
    I18n.with_locale('en') do
      assert_equal 'bar-2', blog_category.slug
    end

    blog_category.delete
  end

  test 'should be valid if name is set properly' do
    blog_category = BlogCategory.new(id: SecureRandom.random_number(1_000))
    blog_category.set_translations(
      fr: { name: 'Foo Foo' },
      en: { name: 'Bar Bar' }
    )

    assert blog_category.valid?, 'should be valid if name is set properly'
    assert_empty blog_category.errors.keys

    I18n.with_locale('fr') do
      assert_equal 'Foo Foo', blog_category.name
      assert_equal 'foo-foo', blog_category.slug
    end
    I18n.with_locale('en') do
      assert_equal 'Bar Bar', blog_category.name
      assert_equal 'bar-bar', blog_category.slug
    end
  end
end
