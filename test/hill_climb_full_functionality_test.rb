require_relative './test_helpers.rb'

# == Full Functionality Tests
# These tests will likely, but not necessarily, pass in subclasses

class TestHillClimbFullFunctionalityTests < Minitest::Test
  
  FactoryGirl.find_definitions
  
  def setup
    @hill_climb = FactoryGirl.build(:hill_climb)
    @hill_climb.extend GetCandidateList
  end
  
  # Immediate success (no further candidates added) when cost is 0
  def test_that_hill_climb_succeeds_when_start_is_acceptable
    @hill_climb.extend GetCost
    
    data = @hill_climb.search
    refute data[:failed]
    # Should include both the first and the last entries in the path
    assert_includes data[:path], @hill_climb.start_vector, "data only includes: \n#{data}"
    refute_includes data[:path], @hill_climb.send(:get_candidate_list)[0], "data only includes: \n#{data}"
  end
  
  # One candidate added when it is the correct one
  def test_that_hill_climb_includes_successful_candidate
    @hill_climb.define_singleton_method(:get_cost) do |c| 
      c == get_candidate_list[0] ? 0 : 0.5
    end
    
    candidate_list = @hill_climb.send(:get_candidate_list)
    assert_equal 0.5, @hill_climb.send(:get_cost, @start_vector), "Start vector is not correct cost"
    assert_equal 0, @hill_climb.send(:get_cost, candidate_list[0]), "Candidate is not correct cost"
    
    data = @hill_climb.search
    refute data[:failed], "the search failed"
    assert_includes data[:path], @hill_climb.send(:get_candidate_list)[0], "data only includes: \n#{data}"    
  end
  
  def test_that_climb_gets_closer_with_each_addition_to_path
    # skip "Should have a series of assertions on every point"
    @hill_climb.define_singleton_method(:get_cost) do |c| 
      c == get_candidate_list[0] ? 0 : 0.5
    end
    
    data = @hill_climb.search
    data[:path][1...data[:path].size].each_with_index do |p, i|
      assert_operator @hill_climb.send(:get_cost, data[:path][i]), :>, @hill_climb.send(:get_cost, p), "check #{data[:path][i]}.cost > #{p}.cost"
    end
  end
end