# frozen_string_literal: true
# == Schema Information
#
# Table name: blog_settings
#
#  id         :integer          not null, primary key
#  prev_next  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == BlogSetting Model
#
class BlogSetting < ActiveRecord::Base
  include MaxRowable
end
