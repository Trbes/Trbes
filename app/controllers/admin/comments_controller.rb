module Admin
  class CommentsController < Admin::ApplicationController
    expose(:group) { view_context.present(current_group) }
    expose(:comment, attributes: :comment_attributes)
    expose(:comments, ancestor: :current_group) do |collection|
      collection.order_by_created_at.includes(user: :avatar).page(params[:page])
    end

    def update
      comment.save

      respond_to do |format|
        format.html { redirect_to edit_admin_group_path }
        format.json { respond_with_bip(comment) }
      end
    end

    private

    def comment_attributes
      params.require(:comment).permit(:state)
    end
  end
end
