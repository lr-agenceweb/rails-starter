# frozen_string_literal: true

#
# == GuestBooks Controller
#
class GuestBooksController < ApplicationController
  include ModuleSettingable

  before_action :guest_book_module_enabled?
  before_action :set_guest_books

  # GET /livre-d-or
  # GET /livre-d-or.json
  def index
    @guest_book = GuestBook.new
    seo_tag_index category
  end

  # POST /livre-d-or
  # POST /livre-d-or.json
  def create
    @guest_book = GuestBook.new(guest_book_params)
    if @guest_book.save
      @guest_book = CommentDecorator.decorate(@guest_book)
      flash.now[:success] = I18n.t('comment.create_success')
      flash.now[:success] = I18n.t('comment.create_success_with_validate') if @guest_book_setting.should_validate?
      respond_action 'create', false
    else
      respond_action :index, false
    end
  end

  private

  def guest_book_params
    params.require(:guest_book).permit(:username, :email, :lang, :content, :nickname)
  end

  def set_guest_books
    guest_books = GuestBook.validated.by_locale(@language)
    @guest_books = CommentDecorator.decorate_collection(guest_books.page(params[:page]))
  end

  def respond_action(template, should_render = false)
    respond_to do |format|
      format.html { redirect_to guest_books_path } unless should_render
      format.html { render template } if should_render
      format.js { render template }
    end
  end

  def guest_book_module_enabled?
    not_found unless @guest_book_module.enabled?
  end
end
