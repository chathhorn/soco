# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define() do

  create_table "cis_courses", :force => true do |t|
    t.column "cis_subject_id", :integer,                               :null => false
    t.column "number",         :integer, :limit => 3,                  :null => false
    t.column "title",          :string,  :limit => 30, :default => "", :null => false
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
    t.column "crn",             :integer,                               :null => false
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

  create_table "course_plans", :force => true do |t|
    t.column "semester_id", :integer, :null => false
  end

  create_table "friends_users", :id => false, :force => true do |t|
    t.column "friend_id", :integer, :null => false
    t.column "user_id",   :integer, :null => false
  end

  create_table "majors", :force => true do |t|
    t.column "name",       :string,                :default => "", :null => false
    t.column "college_id", :integer, :limit => 10,                 :null => false
  end

  create_table "semesters", :force => true do |t|
    t.column "user_id",  :integer,                            :null => false
    t.column "year",     :integer, :limit => 4,               :null => false
    t.column "semester", :enum,    :limit => [:SP, :SU, :FA], :null => false
  end

  create_table "users", :force => true do |t|
    t.column "username",      :string,                             :default => "", :null => false
    t.column "password_hash", :binary,                             :default => "", :null => false
    t.column "first_name",    :string,                             :default => "", :null => false
    t.column "last_name",     :string,                             :default => "", :null => false
    t.column "email",         :string,                             :default => "", :null => false
    t.column "start_year",    :integer, :limit => 4,                               :null => false
    t.column "start_sem",     :enum,    :limit => [:SP, :SU, :FA],                 :null => false
    t.column "birthday",      :date,                                               :null => false
    t.column "college_id",    :integer, :limit => 10,                              :null => false
    t.column "major_id",      :integer, :limit => 10,                              :null => false
  end

  add_index "users", ["username"], :name => "username", :unique => true

end
