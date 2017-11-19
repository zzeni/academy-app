require 'rails_helper'

RSpec.describe "courses/new", type: :view do
  before(:each) do
    assign(:course, Course.new(
      :name => "MyString",
      :category_id => 1,
      :level => 1,
      :max_participants => 1
    ))
  end

  it "renders new course form" do
    render

    assert_select "form[action=?][method=?]", courses_path, "post" do

      assert_select "input[name=?]", "course[name]"

      assert_select "input[name=?]", "course[category_id]"

      assert_select "input[name=?]", "course[level]"

      assert_select "input[name=?]", "course[max_participants]"
    end
  end
end
