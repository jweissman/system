class RemoteMountsController < ApplicationController
  def new
    @target = Folder.find(remote_mount_params[:target_id])
    @remote_mount = RemoteMount.new(target_id: @target.id)
  end

  def create
    @target = Folder.find(remote_mount_params[:target_id])
    @remote_mount = RemoteMount.create(remote_mount_params.merge(source_path: "/"))
    if @remote_mount.save
      flash[:notice] = "remote mount created"
      redirect_to page_url(@target.path) #remote_mount.path)
    else
      flash[:alert] = "oh no, we couldn't do it: #{@remote_mount.errors}"
      render :new
    end
  end

  private
  def remote_mount_params
    params.require(:remote_mount).permit(:target_id, :source_path, :host)
  end
end
