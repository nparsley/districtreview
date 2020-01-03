class PhotosController < ApplicationController
    before_action :authenticate_user!

  def create
    @share = Share.find(params[:share_id])
    @share.photos.create(photo_params.merge(user: current_user))
    redirect_to share_path(@share)
  end

  private

  def photo_params
    params.require(:photo).permit(:caption, :picture)
  end
end

