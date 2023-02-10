class ItemsController < ApplicationController
  def index
  end

  def show
  end

  def create
    redirect_to item_url(:one, name: item_params[:name])
  end

  private

  def item_params
    params.require(:item).permit(:name)
  end
end
