require 'rails_helper'

RSpec.describe Category, type: :model do

  let(:category) { Category.new(name: 'The Best Category') }

  describe "::save" do
    it 'should save the category if all params are correct' do
      expect(category.save).to eq(true)
      expect(category.errors.size).to eq(0)
      expect(category.persisted?).to eq(true)
    end

    it 'should error if name is not provided' do
      category.first_name = nil
      expect(category.save).to eq(false)
      expect(category.errors.first).to eq([:name, "can't be blank"])
    end
  end
end
