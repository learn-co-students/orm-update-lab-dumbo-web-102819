require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id
  

  def initialize(name, grade, id = nil)
    @name = name 
    @grade = grade
    @id = id
  end 
  def self.create_table
    create_t = <<-create_t
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    create_t
    DB[:conn].execute(create_t)
  end
  def self.drop_table 
    drop_t = <<-drop_t
    DROP TABLE students
    drop_t
    DB[:conn].execute(drop_t)
  end 
  def save 
    if self.id
      self.update
    else
      save_me = <<-save_me
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      save_me
      DB[:conn].execute(save_me, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end 
  end 
  def self.create(name, grade)
    student_instance = Student.new(name, grade)
    student_instance.save
    student_instance
  end 
  def self.new_from_db(row)
    Student.new(row[1], row[2], row[0])
  end 
  def update
    update_me_please = <<-update_me_please
    UPDATE students
    SET name = ?, grade = ?, id = ?
    WHERE id = ?
    update_me_please
    DB[:conn].execute(update_me_please, self.name, self.grade, self.id, self.id)
  end
  def self.find_by_name(name_argument)
    find_me_please = <<-hellohi
    SELECT *
    FROM students
    WHERE name = ?
    LIMIT 1
    hellohi

    DB[:conn].execute(find_me_please, name_argument).map do |row|
      self.new_from_db(row)
    end.first 
  end 
end
