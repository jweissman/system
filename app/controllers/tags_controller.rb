class TagsController < ApplicationController
  def show
    @tag = Tag.new(tag_params)
  end

  private
  def tag_params
    params.require(:name)
  end
end
