# frozen_string_literal: true

#
# BlogSetting Model
# ===================
class BlogSetting < ApplicationRecord
  include MaxRowable
end

# == Schema Information
#
# Table name: blog_settings
#
#  id                 :integer          not null, primary key
#  prev_next          :boolean          default(FALSE)
#  show_last_posts    :boolean          default(TRUE)
#  show_categories    :boolean          default(TRUE)
#  show_last_comments :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
