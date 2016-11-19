class PagesController < ApplicationController
  def show
    target = path_params[:path]
    themed = path_params[:themed] != 'false'

    if target
      @resource = Path.dereference('/' + target)
      not_found(target) unless @resource
    else
      @resource = Folder.root
    end

    respond_to do |format|
      format.html do
        if !!themed && @resource.themed?
          render @resource.active_theme #, layout: @resource.active_theme
        else
          p [ :unthemed! ]
          render :show #, layout: 'application'
        end
      end
      format.json { render json: @resource }
    end
  end

  def not_found(path)
    raise ActionController::RoutingError.new("Not found: #{path}")
  end

  private
  def path_params
    params.permit(:path, :themed)
  end
end
