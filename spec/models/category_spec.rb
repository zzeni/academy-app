require 'rails_helper'

RSpec.describe Category, type: :model do

  let(:category) { Fabricate.build(:category, name: "Bla bla bla") }

  describe "::save" do
    it 'should save the category if all params are correct' do
      expect(category.save).to eq(true)
      expect(category.errors.size).to eq(0)
      expect(category.persisted?).to eq(true)
    end

    it 'should error if name is not provided' do
      category.name = nil
      expect(category.save).to eq(false)
      expect(category.errors.first).to eq([:name, "can't be blank"])
    end

    it 'should error if the name longer than 30 characters' do
      category.name = 'A'*31
      expect(category.save).to eq(false)
      expect(category.errors.first).to eq([:name, "is too long (maximum is 30 characters)"])
    end

    it 'should error if name is duplicated' do
      Fabricate(:category, name: category.name)
      expect(category.save).to eq(false)
      expect(category.errors.first).to eq([:name, "has already been taken"])
    end
  end
end
