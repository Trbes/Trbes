module Admin
  class CollectionsController < Admin::ApplicationController
    before_action :ensure_group_is_loaded!
    before_action { authorize(collection_post) }

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
      flash[:notice] = if collection.save
        %Q{Collection "#{collection.name}" was successfully updated}
      else
        collection.errors.full_messages.join(". ")
      end

      respond_to do |format|
        format.html { redirect_to(edit_admin_group_path) }
        format.json { respond_with_bip(collection) }
      end
    end

    def destroy
      flash[:notice] = %Q{Collection "#{collection.name}" has been deleted}

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
