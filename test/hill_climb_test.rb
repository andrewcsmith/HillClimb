require 'minitest/autorun'
require_relative '../lib/hill_climb.rb'
require_relative './test_helpers.rb'

class TestHillClimb < Minitest::Test
  
  def setup
    @start_vector = [2,4,5]
    @goal = 0.5
    @hill_climb = HillClimb.new(@start_vector, @goal, :debug_level => 0)
  end
  
  def test_that_hill_climb_raises_nomethoderror
    assert_raises NoMethodError do
      @hill_climb.search
    end
  end
  
  def test_that_hill_climb_requires_get_cost
    @hill_climb.extend GetCost
    assert_raises NoMethodError do
      @hill_climb.search
    end
  end
  
  def test_that_hill_climb_requires_get_candidate_list
    @hill_climb.extend GetCandidateList
    assert_raises NoMethodError do
      @hill_climb.search
    end
  end
  
  # == Unit Tests
  # Note that the following tests should also pass for any subclass of HillClimb
  
  def test_that_initial_run_begins_at_true
    @hill_climb.extend GetCost
    @hill_climb.send(:prepare_search)
    assert @hill_climb.instance_variable_get(:@initial_run)
  end
  
  def test_that_interval_index_begins_at_0
    @hill_climb.extend GetCost
    @hill_climb.send(:prepare_search)
    @hill_climb.send(:prepare_each_run)
    assert_equal 0, @hill_climb.instance_variable_get(:@interval_index)
  end
  
  def test_that_current_cost_begins_at_cost_of_start_point
    @hill_climb.extend GetCost
    @hill_climb.send(:prepare_search)
    @hill_climb.send(:prepare_each_run)
    
    assert_equal @hill_climb.send(:get_cost, @start_vector), @hill_climb.instance_variable_get(:@current_cost)
  end
  
  def test_that_prepare_each_run_sets_initial_run_to_false
    @hill_climb.extend GetCost
    @hill_climb.send(:prepare_search)
    assert @hill_climb.instance_variable_get(:@initial_run), "@initial_run should be true initially"
    @hill_climb.send(:prepare_each_run)
    refute @hill_climb.instance_variable_get(:@initial_run), "@initial_run should be false after run is prepared"
  end
  
  def test_that_jump_back_decreases_path_size_by_1
    skip "Not yet written"
  end
  
  def test_that_jump_back_changes_current_point_to_most_recent
    skip "Not yet written"
  end
  
  # == Full Functionality Tests
  # These tests will likely, but not necessarily, pass in subclasses
  
  # Immediate success (no further candidates added) when cost is 0
  def test_that_hill_climb_succeeds_when_start_is_acceptable
    @hill_climb.extend GetCost, GetCandidateList
    
    data = @hill_climb.search
    refute data[:failed]
    # Should include both the first and the last entries in the path
    assert_includes data[:path], [2,4,5], "data only includes: \n#{data}"
    refute_includes data[:path], [4,5,6], "data only includes: \n#{data}"
  end
  
  # One candidate added when it is the correct one
  def test_that_hill_climb_includes_successful_candidate
    @hill_climb.extend GetCandidateList
    @hill_climb.define_singleton_method(:get_cost) {|c| c == [4,5,6] ? 0 : 0.5}
    
    candidate_list = @hill_climb.send(:get_candidate_list)
    assert_equal 0.5, @hill_climb.send(:get_cost, @start_vector), "Start vector is not correct cost"
    assert_equal 0, @hill_climb.send(:get_cost, candidate_list[0]), "Candidate is not correct cost"
    
    data = @hill_climb.search
    refute data[:failed], "the search failed"
    assert_includes data[:path], [4,5,6], "data only includes: \n#{data}"    
  end
  
  def test_that_climb_gets_closer_with_each_addition_to_path
    # skip "Should have a series of assertions on every point"
    @hill_climb.extend GetCandidateList
    @hill_climb.define_singleton_method(:get_cost) {|c| c == [4,5,6] ? 0 : 0.5}
    
    data = @hill_climb.search
    data[:path][1...data[:path].size].each_with_index do |p, i|
      assert_operator @hill_climb.send(:get_cost, data[:path][i]), :>, @hill_climb.send(:get_cost, p), "check #{data[:path][i]}.cost > #{p}.cost"
    end
  end
end