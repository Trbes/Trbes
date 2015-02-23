module Admin
  class PostsController < Admin::ApplicationController
    expose(:group) { view_context.present(current_group) }
    expose(:post, attributes: :post_attributes)

    def update
      post.save

      respond_to do |format|
        format.html { redirect_to edit_admin_group_path }
        format.json { respond_with_bip(post) }
      end
    end

    private

    def post_attributes
      params.require(:post).permit(:state)
    end
  end
end
