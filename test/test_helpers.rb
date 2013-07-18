require 'minitest/autorun'
require 'factory_girl'
require_relative '../lib/hill_climb.rb'

# Fake methods that just remove the exceptions raised
module GetCost
  # Returns a cost of 0
  def get_cost candidate
    0
  end
end

module GetCandidateList
  @@candidates = (1..12).to_a.sample(3)
  # Returns a single candidate with the correct answer
  def get_candidate_list
    [@@candidates]
  end
end