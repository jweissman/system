class FoldersController < ApplicationController
  def index
    @parent = if params[:path]
                Path.dereference('/' + params[:path])
              else
                Folder.root
              end

    @folders = @parent.children
    respond_to do |format|
      format.json { render json: @folders }
    end
  end

  def new
    parent = Folder.find(folder_params[:parent_id])
    @folder = Folder.new(parent: parent)
  end

  def create
    @folder = Folder.new(folder_params.merge(user: current_user))
    if @folder.save then
      redirect_to page_url(@folder.path), notice: "folder #{@folder.title} created"
    else
      flash[:alert] = @folder.errors.full_messages
      redirect_to Folder.root
    end
  end

  def destroy
    @folder = Folder.find(params[:id])
    raise "Cannot delete root" if @folder.title == "/"

    parent = @folder.parent
    if @folder.destroy then
      redirect_to page_url(parent.path), notice: "folder #{@folder.title} destroyed"
    else
      flash[:alert] = @folder.errors.full_messages
      redirect_to page_url(@folder.path)
    end
  end

  private
    def folder_params
      params.require(:folder).permit(:title, :parent_id)
    end
end
