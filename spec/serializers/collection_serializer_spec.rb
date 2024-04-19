require 'rails_helper'

RSpec.describe CollectionSerializer do
  let(:scope) { create_list(:company, 1) }
  let(:item_serializer) { CompanySerializer }

  it "serializes the collection" do
    actual = CollectionSerializer.new(scope, item_serializer).call
    expected = scope.map { |item| item_serializer.new(item).call }
    expect(actual).to eq(expected)
  end
end
