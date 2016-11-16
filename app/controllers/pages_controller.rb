class PagesController < ApplicationController
  def show
    target = path_params[:path]
    if target
      @resource = Path.dereference('/' + target)
      not_found(target) unless @resource
    else
      @resource = Folder.root
    end

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @resource }
    end
  end

  def not_found(path)
    raise ActionController::RoutingError.new("Not found: #{path}")
  end

  private
  def path_params
    params.permit(:path)
  end
end
