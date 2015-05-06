module V1
  class PostsController < V1::ApiController
    expose(:posts) do
      scope = current_group.posts
        .includes(:attachments, collection_posts: :collection, membership: :user)
        .public_send(sort_filter)
        .page(params[:page])

      params[:collection_id] ? scope.for_collection(params[:collection_id]) : scope
    end
    expose(:post, attributes: :post_attributes)
    expose(:comments, ancestor: :post) { |collection| collection.root.published.includes(:membership, :child_comments) }

    serialization_scope :view_context

    def index
      render json: {
        posts: posts.map { |post| PostSerializer.new(post, root: false, scope: view_context) },
        total_posts_count: posts.total_count
      }
    end

    def edit
      authorize(post)
    end

    def update
      authorize(post)

      if post.save
        render json: post
      else
        render json: { error: true, messages: post.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    end

    def destroy
      authorize(post)

      post.destroy

      head :ok
    end

    def upvote
      post.upvote_by(current_user)

      render json: post
    end

    def unvote
      post.unvote_by(current_user)

      render json: post
    end

    def feature
      authorize(post)

      post.update_attributes(featured: !post.featured)

      render json: post
    end

    private

    def post_attributes
      # TODO: Encapsulate this into voting.rb somehow
      return if %w(upvote unvote).include?(action_name)

      params.require(:post).permit(
        :title,
        :body,
        :link,
        :post_type,
        attachments_attributes: %i( image id )
      )
    end

    def sort_filter
      params[:sort] || "order_by_votes"
    end
  end
end
