class MountsController < ApplicationController
  def new
    @target = Folder.find(mount_params[:target_id])
    @mount = Mount.new(target: @target)

    @visible_folders = Folder.all
  end

  def create
    @target = Folder.find(mount_params[:target_id])
    @mount = Mount.create(mount_params)
    if @mount.save then
      redirect_to page_url(@target.path), notice: "mount created!"
    else
      flash[:alert] = "there was a problem"
      redirect_to page_url(@target.path)
    end
  end

  private
    def mount_params
      params.require(:mount).permit(:source_id, :target_id)
    end
end
