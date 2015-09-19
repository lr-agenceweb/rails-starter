#
# == GuestBooks Controller
#
class GuestBooksController < ApplicationController
  before_action :set_guest_book
  before_action :guest_book_module_enabled?
  decorates_assigned :guest_book

  # GET /livre-d-or
  # GET /livre-d-or.json
  def index
    seo_tag_index category
  end

  # POST /livre-d-or
  # POST /livre-d-or.json
  def create
    if guest_book_params[:nickname].blank?
      @guest_book = GuestBook.new(guest_book_params)
      @guest_book.validated = @setting.should_validate? ? false : true
      if @guest_book.save
        flash.now[:success] = I18n.t('guest_book.success')
        respond_action 'create', false
      else
        respond_action :index, true
      end
    else # if nickname is filled => robots spam
      flash.now[:error] = 'Captcha caught you'
      respond_action 'captcha', false
    end
  end

  private

  def set_guest_book
    @guest_book = GuestBook.new
    guest_books = GuestBook.validated.by_locale(@language)
    @guest_books = GuestBookDecorator.decorate_collection(guest_books.page params[:page])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def guest_book_params
    params.require(:guest_book).permit(:username, :email, :lang, :content, :nickname)
  end

  def respond_action(template, should_render)
    respond_to do |format|
      format.html { redirect_to guest_books_path, flash: { success: I18n.t('guest_book.success') } } unless should_render
      format.html { render template } if should_render
      format.js { render template }
    end
  end

  def guest_book_module_enabled?
    not_found unless @guest_book_module.enabled?
  end
end
