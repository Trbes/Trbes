class UpdateRoleToMember
  include Interactor

  def call
    publish_everything
  end

  private

  def publish_everything
    # TODO
    puts "Published" * 100
  end
end
