class CreateCollection
  include Interactor

  def call
    context.collection = create_collection

    if context.collection.valid?
      set_success_message
    else
      set_failure_message

      context.fail!
    end
  end

  private

  def set_failure_message
    context.message = context.collection.errors.full_messages.join(". ")
  end

  def set_success_message
    context.message = %Q{"#{context.collection.name}" has been added}
  end

  def create_collection
    Collection.create(context.attributes.merge(group: context.current_group))
  end
end
