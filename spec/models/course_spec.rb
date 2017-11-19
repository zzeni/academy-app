require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:category) { Category.create!(name: "Bla Bla Bla") }
  let(:course) { Course.new(name: "Course 1", level: 1, category: category ) }

  context '::save' do
    it "requires name to be provided" do
      course.name = nil
      course.save
      expect(course.errors.size).to eq(1)
      expect(course.errors.first).to eq([:name, "can't be blank"])
    end

    xit "should error if the name is less than 3 characters" do
      course.name = 'A'
      expect { course.save! }.to raise_error("invalid name")
    end
  end

  context '#complete?' do
    let!(:student1) { Student.create!(first_name: 'Baba', last_name: 'Mii') }
    let!(:student2) { Student.create!(first_name: 'Baba', last_name: 'Tii') }

    before(:each) do
      course.max_participants = 2
      course.students << student1
      course.students << student2
      course.save!
    end

    it "should be true if there are already @max_participants students in the course" do
      expect(course.complete?).to be(true)
    end

    it "should be false if @max_participants is not set" do
      course.update_attribute :max_participants, nil
      expect(course.complete?).to be(false)
    end
  end

  context '#potential?' do
    it "should be true if course has less than minimum required participants" do
      pending "not implemented"
      expect(course.potential?).to be(true)
    end
  end

  context '#actual?' do
    it "should be true if course has less than minimum required participants" do
      pending "not implemented"
      expect(course.actual?).to be(true)
    end
  end
end
