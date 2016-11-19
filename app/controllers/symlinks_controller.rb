class SymlinksController < ApplicationController
  def new
    @target = Folder.find(symlink_params[:target_id])
    @symlink = Symlink.new(target: @target)
  end

  def create
    @target = Folder.find(symlink_params[:target_id])
    @symlink = Symlink.create(symlink_params)

    if @symlink.save then
      redirect_to page_url(@target.path), notice: "symlink created!"
    else
      flash[:alert] = "there was a problem: " + @symlink.errors.full_messages
      redirect_to page_url(@target.path)
    end
  end

  private
  def symlink_params
    params.require(:symlink).permit(:target_id, :source_path)
  end
end
