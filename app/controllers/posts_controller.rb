class PostsController < ApplicationController
  include Voting

  before_action :ensure_trailing_slash, only: %i( show update destroy )
  before_action :ensure_group_is_loaded!, :ensure_group_access_from_canonical_url!, only: [:show]

  expose(:rss_posts) do
    current_group.posts
      .published
      .order_by_created_at
      .limit(8)
      .includes(collection_posts: :collection, membership: :user)
  end
  expose(:posts, ancestor: :current_group)
  expose(:post, attributes: :post_attributes, finder: :find_by_slug) do
    posts.with_deleted.find_by!(slug: params[:id] || params[:post_id])
  end
  expose(:comments, ancestor: :post) do |collection|
    policy_scope(collection.root).includes(:membership, :child_comments)
  end

  def index
    respond_to do |format|
      format.rss do
        render layout: false
      end
    end
  end

  def show
    authorize(post)

    @post_title = post.title
    @group_name = current_group.name
  end

  def edit
    authorize(post)
  end

  def update
    authorize(post)

    flash[:notice] = if post.update_attributes(post_attributes)
      %(Post "#{post.title}" was successfully updated)
    else
      post.errors.full_messages.join(". ")
    end

    redirect_to :back
  end

  def create
    result = CreatePost.call(
      attributes: post_attributes,
      current_membership: current_membership,
      allow_publish: policy(Post).publish?
    )

    redirect_to root_path, flash: { notice: result.message }
  end

  def destroy
    authorize(post)

    post.destroy

    redirect_to root_path
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

  def ensure_trailing_slash
    params[:id] = CGI.unescape request.original_fullpath[1..-1]
  end
end
