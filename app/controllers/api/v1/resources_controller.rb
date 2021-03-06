class Api::V1::ResourcesController < ApplicationController

  def index
    @resources = Resource.page(params[:page] || 1)
    render json: @resources, root: 'items', meta: meta_with_page(@resources)
  end

  def show
    @resource = Resource.find(params[:id])
    render json: @resource
  end

  def create
    if Resource.exists?(filename: params[:filename])
      render json: { error_code: 2 } and return
    end
    @resource = Resource.new
    @resource.assign_attributes(resource_params)
    @resource.owner = current_user.id
    if @resource.save
      render json: {
          error_code: 0,
          resource: @resource
      }
    else
      render json: { error_code: 1 }
    end
  end

  def destroy
    @resource = Resource.find(params[:id])
    if @resource.destroy
      render json: { error_code: 0 }
    else
      render json: { error_code: 1 }
    end
  end

  def resource_params
    params.permit(:filename, :file, :usage)
  end

  private :resource_params

end
