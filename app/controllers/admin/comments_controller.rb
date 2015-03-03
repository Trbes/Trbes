module Admin
  class CommentsController < Admin::ApplicationController
    expose(:comments, ancestor: :current_group) do |collection|
      collection.order_by_created_at.includes(user: :avatar).page(params[:page])
    end
    expose(:comment, attributes: :comment_attributes)

    def update
      comment.save

      respond_to do |format|
        format.html { redirect_to edit_admin_group_path }
        format.json { respond_with_bip(comment) }
      end
    end

    def favourite
      comment.favourite = true
      comment.save

      redirect_to :back
    end

    private

    def comment_attributes
      params.require(:comment).permit(:state)
    end
  end
end
