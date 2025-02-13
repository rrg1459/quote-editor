class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy]

  def index
    @quotes = current_company.quotes.ordered
  end

  def show
    # @line_item_dates = @quote.line_item_dates.ordered
    # this is to avoid N+1 queries  when rendering the view
    @line_item_dates = @quote.line_item_dates.includes(:line_items).ordered
  end

  def new
    @quote = Quote.new
  end

  def create
    # @quote = Quote.new(quote_params)
    @quote = current_company.quotes.build(quote_params)

    if @quote.save
      respond_to do |format|
          flash[:notice] = "Quote was successfully created."
          format.html { redirect_to quotes_path }
          format.turbo_stream { flash.now[:notice] = "Quote was successfully created." }
      end
    else
      # Add `status: :unprocessable_entity` here
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @quote.update(quote_params)
      respond_to do |format|
        flash[:notice] = "Quote was successfully updated."
        format.html { redirect_to quotes_path }
        format.turbo_stream { flash.now[:notice] = "Quote was successfully updated." }
      end
    else
      # Add `status: :unprocessable_entity` here
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quote.destroy
    respond_to do |format|
      flash[:notice] = "Quote was successfully destroyed."
      format.html { redirect_to quotes_path }
      format.turbo_stream { flash.now[:notice] = "Quote was successfully destroyed." }
    end
  end

  private

  def set_quote
    # @quote = Quote.find(params[:id])
    @quote = current_company.quotes.find(params[:id])
  end

  def quote_params
    params.require(:quote).permit(:name)
  end
end