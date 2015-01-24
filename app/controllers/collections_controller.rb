class CollectionsController < ApplicationController
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

    redirect_to(:index)
  end

  private

  def collection_attributes
    params.require(:collection).permit(:image, :name)
  end
end
