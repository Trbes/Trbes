class CollectionsController < ApplicationController
  before_action :ensure_group_is_loaded!
  before_action :authorize_collection, only: %i(new create edit update destroy)

  expose(:collections)
  expose(:collection, attributes: :collection_attributes)

  def create
    collection = CreateCollection.call(
      attributes: collection_attributes,
      current_group: current_group
    ).collection

    respond_with(collection)
  end

  def update
    collection.save

    respond_with(collection)
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