json.extract! course, :id, :name, :category_id, :level, :max_participants, :created_at, :updated_at
json.url course_url(course, format: :json)
