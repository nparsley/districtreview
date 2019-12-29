class SharesController < ApplicationController

  def new
    @share = Share.new
  end

  def index
  end

  def create
    @share = Share.create(share_params)
    if @share.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end


  private


  def share_params
    params.require(:share).permit(:message)
  end

end
