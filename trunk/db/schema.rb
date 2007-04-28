# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 22) do

  create_table "cis_courses", :force => true do |t|
    t.column "cis_subject_id",       :integer,                               :null => false
    t.column "number",               :integer, :limit => 3,                  :null => false
    t.column "title",                :string,  :limit => 30, :default => "", :null => false
    t.column "course_dependency_id", :integer
    t.column "description",          :text
  end

  create_table "cis_courses_course_bins", :id => false, :force => true do |t|
    t.column "cis_course_id", :integer, :null => false
    t.column "course_bin_id", :integer, :null => false
  end

  create_table "cis_courses_semesters", :id => false, :force => true do |t|
    t.column "cis_course_id", :integer, :null => false
    t.column "semester_id",   :integer, :null => false
  end

  create_table "cis_sections", :force => true do |t|
    t.column "cis_semester_id", :integer,                               :null => false
    t.column "crn",             :integer
    t.column "stype",           :string,  :limit => 15, :default => "", :null => false
    t.column "name",            :string,                :default => "", :null => false
    t.column "startTime",       :time
    t.column "endTime",         :time
    t.column "days",            :string,  :limit => 13, :default => "", :null => false
    t.column "room",            :string,                :default => "", :null => false
    t.column "building",        :string,                :default => "", :null => false
    t.column "instructor",      :string,                :default => "", :null => false
  end

  create_table "cis_sections_course_plans", :id => false, :force => true do |t|
    t.column "cis_section_id", :integer, :null => false
    t.column "course_plan_id", :integer, :null => false
  end

  create_table "cis_semesters", :force => true do |t|
    t.column "cis_course_id", :integer,                            :null => false
    t.column "year",          :integer, :limit => 4,               :null => false
    t.column "semester",      :enum,    :limit => [:SP, :SU, :FA], :null => false
  end

  create_table "cis_subjects", :force => true do |t|
    t.column "code", :string, :limit => 6, :default => "", :null => false
  end

  add_index "cis_subjects", ["code"], :name => "code", :unique => true

  create_table "colleges", :force => true do |t|
    t.column "code", :string, :limit => 2,  :default => "", :null => false
    t.column "name", :string, :limit => 45, :default => "", :null => false
  end

  create_table "course_bins", :force => true do |t|
    t.column "user_id", :integer, :null => false
  end

  create_table "course_dependencies", :force => true do |t|
    t.column "node_type", :enum, :limit => [:COURSE, :CONCURRENT, :OR, :AND], :null => false
  end

  create_table "course_dependency_edges", :id => false, :force => true do |t|
    t.column "parent_id", :integer, :null => false
    t.column "child_id",  :integer, :null => false
  end

  create_table "course_plans", :force => true do |t|
    t.column "semester_id", :integer, :null => false
  end

  create_table "course_reviews", :force => true do |t|
    t.column "user_id",       :integer
    t.column "cis_course_id", :integer
    t.column "title",         :string
    t.column "created_on",    :date
    t.column "body",          :text
  end

  create_table "majors", :force => true do |t|
    t.column "name",       :string,  :default => "", :null => false
    t.column "college_id", :integer,                 :null => false
  end

  create_table "relationships", :force => true do |t|
    t.column "friend_id", :integer, :null => false
    t.column "user_id",   :integer, :null => false
  end

  create_table "semesters", :force => true do |t|
    t.column "user_id",  :integer,                            :null => false
    t.column "year",     :integer, :limit => 4,               :null => false
    t.column "semester", :enum,    :limit => [:SP, :SU, :FA], :null => false
  end

  create_table "shared_courses", :force => true do |t|
    t.column "cis_course_id",   :integer, :null => false
    t.column "relationship_id", :integer, :null => false
  end

  create_table "users", :force => true do |t|
    t.column "username",      :string,                             :default => "", :null => false
    t.column "password_hash", :string,                             :default => ""
    t.column "first_name",    :string,                             :default => "", :null => false
    t.column "last_name",     :string,                             :default => "", :null => false
    t.column "email",         :string,                             :default => "", :null => false
    t.column "start_year",    :integer, :limit => 4,                               :null => false
    t.column "start_sem",     :enum,    :limit => [:SP, :SU, :FA],                 :null => false
    t.column "birthday",      :date,                                               :null => false
    t.column "college_id",    :integer,                                            :null => false
    t.column "major_id",      :integer,                                            :null => false
  end

  add_index "users", ["username"], :name => "username", :unique => true

end
