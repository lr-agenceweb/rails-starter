# frozen_string_literal: true
#
# == BlogSweeper caching
#
class BlogSweeper < ActionController::Caching::Sweeper
  observe Blog

  def sweep(blog)
    ActionController::Base.new.expire_fragment blog
    ActionController::Base.new.expire_fragment ['sidebar', blog]
  end

  alias after_update sweep
  alias after_create sweep
  alias after_destroy sweep
end
