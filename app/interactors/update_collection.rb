class UpdateCollection
  include Interactor

  def call
    update_collection

    if context.collection.valid?
      set_success_message
    else
      set_failure_message

      context.fail!
    end
  end

  private

  def update_collection
    context.collection.save
  end

  # TODO: Extract this messages setting logic to separate composite (preferred) or parent class
  def set_success_message
    context.message = %(Collection "#{collection.name}" was successfully updated)
  end

  def set_failure_message
    context.message = collection.errors.full_messages.join(". ")
  end
end
