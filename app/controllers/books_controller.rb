class BooksController < ApplicationController
  include Pagy::Backend
  before_action :set_book, only: %i[ show edit update destroy borrow return notify]

  # GET /books or /books.json
  def index

    @q = Book.ransack(params[:q])
    @books = @q.result(distinct: true)

    @count = @books.count
    #@books = Book.all
    @pagy, @books = pagy(@books)
  end

  # GET /books/1 or /books/1.json
  def show

    id = params[:id]
    @checkdoutby = Checkedout.where({ book_id: id, checkedoutstatus: true })
    @count = @checkdoutby.count
    @pagy, @checkdoutby = pagy(@checkdoutby)

  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def borrow
    redirect_to root_url  if !current_user
    id = params[:id]
    # check to see if book is already checked out no more than 1 copy at a time
    already_checkedout = Checkedout.where({ user: current_user, book_id: id, checkedoutstatus: true })

    if  already_checkedout.count == 0
       Checkedout.create({user: current_user, book: @book, checkedout: Date.today, duedate: Date.today + 7, checkedoutstatus: true })
      flash.alert = @book.Title + " checked out..."
    else
      flash.alert = @book.Title + " already checked out, one copy permitted..."
    end

    redirect_to root_path

  end

  def checkedout

    @checkedout = Checkedout.where('user_id =?', current_user.id).and(Checkedout.where(checkedoutstatus: true))
    @pagy, @checkedout = pagy(@checkedout)

    @count = @checkedout.count

  end

  def booklog

    @booklog = Checkedout.order(:book_id)

    @pagy, @booklog = pagy(@booklog)
    @count = Checkedout.count

  end



  def return
    id = params[:id]
    book = Book.find_by_id(id)
    copies = book.Copies  #number of copies of the book
    taken = Checkedout.where(book_id: id, checkedoutstatus: true).count  # number of books checked out of this id

    remaining = copies - taken  #remaining copies
    onhold = Notify.where(book_id: id).count

    if onhold > 0 and remaining = 0
      # run the mailing script here...lookup each user for this book
      ReminderMailer.reminder_email(book).deliver_now
    end

    returned = Checkedout.where(book_id: id).and(Checkedout.where(checkedoutstatus: true))
    returned.update(checkedoutstatus: false, returndate: Date.today)

    flash.alert =  "book returned..."
    redirect_to root_path

  end

  def notify

    redirect_to root_url  if !current_user
    #add userid and book_id of a book that is not in house
    id = params[:id]
#binding.pry
    @already_notified = Notify.where({ user_id: current_user.id, book_id: id })

    if  @already_notified.count == 0
       Notify.create({user_id: current_user.id, book_id: id })
      flash.alert = @book.Title + " on hold..."
    else
      flash.alert = @book.Title + " already on hold, one copy permitted..."
    end

    redirect_to root_path

  end

  def notificationlog

    @notificationlog = Notify.where({ user_id: current_user})
    @count = @notificationlog.count

  end

  def destroy_notify
    @notify = current_user.notifies.find_by_book_id(params[:id])

    if @notify and @notify.destroy

      respond_to do |format|
        format.html { redirect_to notificationlog_url, notice: "Item on hold was successfully deleted." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to notificationlog_url, notice: "Item on hold failed to delete." }
        format.json { head :no_content }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:Library, :Title, :Author, :Genre, :Subgenre, :Pages, :Publisher, :Copies)
    end
end
