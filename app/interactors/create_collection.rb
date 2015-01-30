class CreateCollection
  include Interactor

  def call
    context.collection = create_collection
  end

  private

  def create_collection
    Collection.create(context.attributes.merge(group: context.current_group))
  end
end
