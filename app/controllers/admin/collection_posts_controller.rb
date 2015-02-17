module Admin
  class CollectionPostsController < Admin::ApplicationController
    expose(:collection_post, attributes: :collection_post_attributes)

    def create
      collection_post.save

      redirect_to :back
    end

    private

    def collection_post_attributes
      params.require(:collection_post).permit(:post_id, :collection_id)
    end
  end
end
