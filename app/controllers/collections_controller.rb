class CollectionsController < ApplicationController
  before_action :ensure_group_is_loaded!

  expose(:collection, attributes: :collection_attributes)

  def create
    CreateCollection.call(
      attributes: collection_attributes,
      current_group: current_group
    )

    redirect_to root_path
  end

  private

  def collection_attributes
    params.require(:collection).permit(
      :image,
      :image_cache,
      :name,
      :visibility,
      :row_order_position,
      collection_posts_attributes: %i( post_id id _destroy )
    )
  end
end
