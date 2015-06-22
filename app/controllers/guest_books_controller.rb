#
# == GuestBooks Controller
#
class GuestBooksController < ApplicationController
  decorates_assigned :guest_book

  # GET /guest-book
  # GET /guest-book.json
  def index
    @guest_books = GuestBook.validated
  end

  # POST /guest-book
  # POST /guest-book.json
  def create
    if guest_book_params[:nickname].blank?
      @guest_book = @guest_book.new(comment_params)
      if @guest_book.save
        flash.now[:success] = 'Message was successfully created.'
        respond_action 'create', true
      else
        render :index
      end
    else # if nickname is filled => robots spam
      flash.now[:error] = 'Captcha caught you'
      respond_action 'captcha', false
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:guest_book).permit(:username, :lang, :content)
  end

  def respond_action(template, success)
    respond_to do |format|
      format.html { redirect_to guest_books_path }
      format.js { render template }
    end
  end
end
