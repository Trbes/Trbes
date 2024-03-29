module Admin
  class CollectionsController < Admin::ApplicationController
    before_action :ensure_group_is_loaded!
    before_action { authorize(collection) }

    expose(:collections)
    expose(:collection, attributes: :collection_attributes)

    def create
      result = CreateCollection.call(
        attributes: collection_attributes,
        current_group: current_group
      )

      flash[:notice] = result.message

      redirect_to :back
    end

    def update
      result = UpdateCollection.call(collection: collection)

      flash[:notice] = result.message

      respond_to do |format|
        format.html { redirect_to(edit_admin_group_path) }
        format.json { respond_with_bip(result.collection) }
      end
    end

    def destroy
      flash[:notice] = %(Collection "#{collection.name}" has been deleted)

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
