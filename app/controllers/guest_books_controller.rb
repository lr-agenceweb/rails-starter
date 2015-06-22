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
end
