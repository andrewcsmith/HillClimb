require 'factory_girl'
require_relative '../../lib/hill_climb.rb'

FactoryGirl.define do
  factory :hill_climb do
    ignore do
      start_vector (1..12).to_a.sample(3)
      goal_vector 1.0
    end
    debug_level 0
    initialize_with {HillClimb.new(start_vector, goal_vector)}
  end
end