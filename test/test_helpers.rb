# Fake methods that just remove the exceptions raised
module GetCost
  # Returns a cost of 0
  def get_cost candidate
    0
  end
end

module GetCandidateList
  # Returns a single candidate with the correct answer
  def get_candidate_list
    [[4,5,6]]
  end
end