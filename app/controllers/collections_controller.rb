class CollectionsController < ApplicationController
  before_action :authorize_collection, only: %i(new create edit update destroy)

  expose(:collections)
  expose(:collection, attributes: :collection_attributes)

  def create
    collection.group = current_group

    if collection.save
      redirect_to(collection)
    else
      redirect_to(:new)
    end
  end

  def update
    if collection.save
      redirect_to(collection)
    else
      redirect_to(:edit)
    end
  end

  def destroy
    collection.destroy

    render(:index)
  end

  private

  def authorize_collection
    authorize(collection)
  end

  def collection_attributes
    params.require(:collection).permit(:image, :name)
  end
end
