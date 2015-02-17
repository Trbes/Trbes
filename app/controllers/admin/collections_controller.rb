module Admin
  class CollectionsController < Admin::ApplicationController
    before_action :ensure_group_is_loaded!

    expose(:collections)
    expose(:collection, attributes: :collection_attributes)

    def create
      collection = CreateCollection.call(
        attributes: collection_attributes,
        current_group: current_group
      ).collection

      respond_with(collection, location: [:admin, collection])
    end

    def update
      success = collection.update_attributes(collection_attributes)

      respond_to do |format|
        format.html { success ? redirect_to([:admin, collection]) : render(:edit) }
        format.json { respond_with_bip(collection) }
      end
    end

    def destroy
      collection.destroy

      render(:index)
    end

    private

    def collection_attributes
      params.require(:collection).permit(:image, :name, :visibility)
    end
  end
end
