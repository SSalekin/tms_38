class CourseSubject < ActiveRecord::Base
  belongs_to :course
  belongs_to :subject

  validates :course_id, uniqueness: {scope: :subject_id}

  after_save :enroll_subject_to_user
  after_destroy :delete_subject_users

  private
  def enroll_subject_to_user
    course.course_users.each do |course_user|
      subject.user_subjects.create user_id: course_user.user_id,
        course_id: course_id
    end
  end

  def delete_subject_users
    course.user_subjects.search_by_subject(subject_id).delete_all
  end
end
