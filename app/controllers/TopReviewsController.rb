class TopReviewsController < ApplicationController

	def grab_reviews
		
		top_20_comments = {}
		vote_array = Vote.all.pluck(:"voteable_id")
		freq = vote_array.inject(Hash.new(0)) { |h,v| h[v] += 1; h }

		(0...20).each do
			top_vote = vote_array.max_by { |v| freq[v]}
			top_review = Review.find_by(id: top_vote)

			top_comment = top_review["comment"]
			top_course = Course.find(top_review["course_id"])

			top_20_comments[top_course] = top_comment

			top_20_comments.append(top_comment)
			freq.delete(top_vote)
		end

		return top_20_comments



