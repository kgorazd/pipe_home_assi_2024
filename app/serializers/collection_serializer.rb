# frozen_string_literal: true

class CollectionSerializer
  attr_reader :collection, :item_serializer

  def initialize(collection, item_serializer)
    @collection = collection
    @item_serializer = item_serializer
  end

  def call
    collection.map { |item| item_serializer.new(item).call }
  end
end
