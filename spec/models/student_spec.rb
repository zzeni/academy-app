require 'rails_helper'

RSpec.describe Student, type: :model do
  let(:student) { Student.new(first_name: 'Baba', last_name: 'Miii') }

  describe "::save" do
    it 'should error if first_name is not specified' do
      student.first_name = nil
      expect(student.save).to eq(false)
      expect(student.errors.first).to eq([:first_name, "can't be blank"])
    end

    it 'should error if last_name is not specified' do
      student.last_name = nil
      student.save
      expect(student.errors.first).to eq([:last_name, "can't be blank"])
    end

    it 'should error if first_name is longer than 15 characters' do
      student.first_name = 'A'*16
      expect(student.save).to eq(false)
      expect(student.errors.first).to eq([:first_name, "is too long (maximum is 15 characters)"])
    end

    it 'should error if last_name is not specified' do
      student.last_name = 'A'*16
      expect(student.save).to eq(false)
      expect(student.errors.first).to eq([:last_name, "is too long (maximum is 15 characters)"])
    end

    it 'should save the user if all params are correct' do
      expect(student.save).to eq(true)
      expect(student.errors.size).to eq(0)
      expect(student.persisted?).to eq(true)
    end
  end
end
