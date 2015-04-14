module Admin
  class CollectionPostsController < Admin::ApplicationController
    before_action { authorize(collection_post) }

    expose(:collection_post, attributes: :collection_post_attributes)

    def create
      flash[:notice] = %Q{Post was added to "#{collection_post.collection_name}"}
      collection_post.save

      redirect_to :back
    end

    def destroy
      flash[:notice] = %Q{Post was removed from "#{collection_post.collection_name}"}

      collection_post.destroy

      redirect_to root_path
    end

    private

    def collection_post_attributes
      params.require(:collection_post).permit(:post_id, :collection_id, :row_order_position)
    end
  end
end
