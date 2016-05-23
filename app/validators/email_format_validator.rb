# frozen_string_literal: true

#
# == Email validator
#
class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attr_name, value)
    record.errors.add(attr_name, :email, options.merge(value: value)) unless value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  end
end
