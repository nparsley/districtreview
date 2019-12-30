class SharesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  
  def destroy
    @share = Share.find_by_id(params[:id])
    return render_not_found if @share.blank?
    @share.destroy
    redirect_to root_path
  end

  def update
    @share = Share.find_by_id(params[:id])
    return render_not_found if @share.blank?

    @share.update_attributes(share_params)
      
    if @share.valid?
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def new
    @share = Share.new
  end

  def index
  end

  def show
    @share = Share.find_by_id(params[:id])
    if @share.blank?
      return render_not_found if @share.blank?
    end
  end

  def edit
    @share = Share.find_by_id(params[:id])
    if @share.blank?
      return render_not_found if @share.blank?
    end
  end

  def create
    @share = current_user.shares.create(share_params)
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

  def render_not_found
    render plain: 'Not Found :(', status: :not_found
  end

end
