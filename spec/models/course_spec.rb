require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:category) { Category.create!(name: "Bla Bla Bla") }
  let!(:student1) { Student.create!(first_name: 'Baba', last_name: 'Mii') }
  let!(:student2) { Student.create!(first_name: 'Baba', last_name: 'Tii') }
  let(:course) { Course.new(name: "Course 1", level: 1, category: category ) }

  context '#save' do
    it 'should save the category if all params are correct' do
      expect(course.save).to eq(true)
      expect(course.errors.size).to eq(0)
      expect(course.persisted?).to eq(true)
    end

    it "requires name to be provided" do
      course.name = nil
      course.save
      expect(course.errors.first).to eq([:name, "can't be blank"])
    end

    it "should error if the name is less than 3 characters" do
      course.name = 'A'
      expect(course.save).to eq(false)
      expect(course.errors.first).to eq([:name, "is too short (minimum is 3 characters)"])
    end

    it 'should error if the name longer than 50 characters' do
      course.name = 'A'*51
      expect(course.save).to eq(false)
      expect(course.errors.first).to eq([:name, "is too long (maximum is 50 characters)"])
    end

    it 'should error if the category is missing' do
      course.category = nil
      expect(course.save).to eq(false)
      expect(course.errors.first).to eq([:category, "must exist"])
    end

    it 'should error if the level is not one of 1, 2, 3' do
      course.level = 4
      expect(course.save).to eq(false)
      expect(course.errors.first).to eq([:level, "must be less than or equal to 3"])
    end

    context "when another course with the same name exists" do
      let!(:other_course) {
        Course.create!(name: course.name, category: category, level: course.level)
      }

      context "in a different category" do
        before(:each) do
          other_course.category = Category.create!(name: "Other category")
          other_course.save!
        end

        it "should not conflict" do
          expect(course.save).to eq(true)
          expect(course.errors.size).to eq(0)
          expect(course.persisted?).to eq(true)
        end
      end

      context "in the same category" do
        it 'should error if has the same level' do
          expect(course.save).to eq(false)
          expect(course.errors.first).to eq([:name, "has already been taken"])
        end

        it 'should not conflict if has a different level' do
          course.level += 1
          expect(course.save).to eq(true)
          expect(course.errors.size).to eq(0)
          expect(course.persisted?).to eq(true)
        end
      end
    end
  end

  context '#complete?' do
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
    before(:each) do
      course.save!
    end

    context "when min_participants is not set" do
      it "should be false" do
        expect(course.potential?).to be(false)
      end
    end

    context "when min_participants is set" do
      before(:each) do
        course.update_attribute :min_participants, 2
        course.students << student1
      end

      it "should be false if there are enough students enrolled" do
        course.students << student2
        expect(course.potential?).to be(false)
      end

      it "should be true if less students than min_participants have enrolled" do
        expect(course.potential?).to be(true)
      end
    end
  end

  context '#actual?' do
    before(:each) do
      course.save!
    end

    context "when min_participants is not set" do
      it "should be false" do
        expect(course.potential?).to be(false)
      end
    end
  end

  context '::actual' do
    before(:each) do
      course.save!
    end

    it "should not select courses that have not set min_participants" do
      expect(Course.actual.to_a.size).to eq(0)
    end

    it "should select courses that have min_participants set to 0" do
      course.update(min_participants: 0)
      expect(Course.actual.to_a.size).to eq(1)
    end

    it "should select courses that have min_participants set to positive number and at least same number of students enrolled" do
      course.update(min_participants: 2)
      course.students << student1
      course.students << student2

      expect(Course.actual.to_a.size).to eq(1)
    end

    it "should not select courses that have min_participants set to positive number and not as much students enrolled" do
      course.update(min_participants: 2)
      course.students << student1

      expect(Course.actual.to_a.size).to eq(0)
    end
  end
end
