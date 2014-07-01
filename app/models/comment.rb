class Comment < ActiveRecord::Base

  validate :review_xor_comment_as_parent, before: :save
  # validate :parent_cannot_be_self, after: :save
  validates_presence_of :text


  def parent
    if self.review_id.present?
      return Review.find(self.review_id)
    elsif self.comment_id.present?
      return Comment.find(self.comment_id)
    else
      return nil
    end
  end

  def children
    return Comment.find_by(comment_id: self.id)
  end


  private

  def review_xor_comment_as_parent
    if self.review_id.nil? and self.comment_id.nil?
      errors.add(:review_id, "Comment must have a parent.")
      errors.add(:comment_id, "Comment must have a parent.")
    elsif self.review_id.present? and self.comment_id.present?
      errors.add(:review_id, "Comment cannot have both a review and comment as a parent.")
      errors.add(:comment_id, "Comment cannot have both a review and comment as a parent.")
    end     
  end

  # def parent_cannot_be_self
  #   if self.comment_id == self.id
  #     self.destroy
  #     errors.add(:comment_id, "Comment's parent cannot be itself.")
  #   end 
  # end

  

end
