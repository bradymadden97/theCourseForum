# this model is based on attributes from review.rb

class faq < ActiveRecord::Base
    belongs_to :user, foreign_key: :student_id
    belongs_to :course
    belongs_to :professor # the question could be specifically about the professor

    has_many :answers # need to create this model

    # add to course model : has_many :FAQs
    #                       has_many :answers, :through => FAQs

    acts_as_voteable # questions can be voted on

    # also probably need to validate the presence of the text of the question
    # but the variable hasn't been created yet/does it need to be?
    validates_presence_of :student_id, :course_id, :professor_id

    # is this necessary??? --> it comes from review.rb
    validates_uniqueness_of :student_id, :scope => [:course_id, :professor_id]

    # next step is to create question_controller.rb

end
