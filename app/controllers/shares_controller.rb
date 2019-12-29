class SharesController < ApplicationController

  def new
    @share = Share.new
  end

  def index
  end

  def create
    @share = Share.create(share_params)
    redirect_to root_path
  end


  private


  def share_params
    params.require(:share).permit(:message)
  end

end
