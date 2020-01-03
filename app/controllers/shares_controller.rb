class SharesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  
  def destroy
    @share = Share.find_by_id(params[:id])
    return render_not_found if @share.blank?
    return render_not_found(:forbidden) if @share.user != current_user
    @share.destroy
    redirect_to root_path
  end

  def update
    @share = Share.find_by_id(params[:id])
    return render_not_found if @share.blank?
    return render_not_found(:forbidden) if @share.user != current_user
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
    @shares = Share.all
  end

  #def index
    #@shares = Share.order("name").page(params[:page]).per_page(4)
  #end

  def show
    @share = Share.find_by_id(params[:id])
    if @share.blank?
      return render_not_found if @share.blank?
    end
    @comment = Comment.new
    @photo = Photo.new
  end

  def edit
    @share = Share.find_by_id(params[:id])
    return render_not_found if @share.blank?
    return render_not_found(:forbidden) if @share.user != current_user
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
    params.require(:share).permit(:name, :description, :address)
  end

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} :(", status: status
  end

end
