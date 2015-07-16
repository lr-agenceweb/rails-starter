#
# == AdultsController
#
class AdultsController < ApplicationController
  before_action :check_adult_cookie
  skip_before_action :set_adult_validation
  skip_before_action :set_menu_elements
  skip_before_action :set_newsletter_user
  skip_before_action :set_host_name
  skip_before_action :set_background

  layout 'adults'

  def index
  end

  def create
    if params[:adult][:adult_validated] == '1'
      cookies[:adult_validated] = { value: 'adult', expires: 1.week.from_now }
      redirect_to root_path
    else
      redirect_to adults_path
    end
  end

  private

  def check_adult_cookie
    if !@adult_module.enabled? || !cookies[:adult_validated].nil?
      redirect_to root_path
    end
  end
end
