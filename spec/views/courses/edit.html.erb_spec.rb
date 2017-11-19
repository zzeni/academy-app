require 'rails_helper'

RSpec.describe "courses/edit", type: :view do
  before(:each) do
    @course = assign(:course, Course.create!(
      :name => "MyString",
      :category_id => 1,
      :level => 1,
      :max_participants => 1
    ))
  end

  it "renders the edit course form" do
    render

    assert_select "form[action=?][method=?]", course_path(@course), "post" do

      assert_select "input[name=?]", "course[name]"

      assert_select "input[name=?]", "course[category_id]"

      assert_select "input[name=?]", "course[level]"

      assert_select "input[name=?]", "course[max_participants]"
    end
  end
end
