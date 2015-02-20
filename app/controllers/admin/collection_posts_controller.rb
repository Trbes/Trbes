module Admin
  class CollectionPostsController < Admin::ApplicationController
    expose(:collection_post, attributes: :collection_post_attributes)

    def create
      collection_post.save

      redirect_to :back
    end

    def update
      collection_post.save

      redirect_to edit_admin_group_path
    end

    def destroy
      collection_post.destroy

      redirect_to root_path
    end

    private

    def collection_post_attributes
      params.require(:collection_post).permit(:post_id, :collection_id, :row_order_position)
    end
  end
end
