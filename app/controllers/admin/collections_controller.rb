module Admin
  class CollectionsController < Admin::ApplicationController
    before_action :ensure_group_is_loaded!

    expose(:collections)
    expose(:collection, attributes: :collection_attributes)

    def create
      CreateCollection.call(
        attributes: collection_attributes,
        current_group: current_group
      )

      redirect_to :back
    end

    def update
      collection.save

      respond_to do |format|
        format.html { redirect_to(edit_admin_group_path) }
        format.json { respond_with_bip(collection) }
      end
    end

    def destroy
      collection.destroy

      redirect_to edit_admin_group_path
    end

    private

    def collection_attributes
      params.require(:collection).permit(
        :name,
        :visibility,
        :row_order_position,
        :icon_class,
        collection_posts_attributes: %i( post_id id _destroy )
      )
    end
  end
end
