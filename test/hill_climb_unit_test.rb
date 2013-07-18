require_relative './test_helpers.rb'

# == Unit Tests
# The following tests should also pass for any subclass of HillClimb

class TestHillClimbUnits < Minitest::Test
  
  FactoryGirl.find_definitions
  
  def setup
    @hill_climb = FactoryGirl.build(:hill_climb)
    @hill_climb.extend GetCost
  end
  
  def test_that_initial_run_begins_at_true
    @hill_climb.send(:prepare_search)
    assert @hill_climb.initial_run
  end
  
  def test_that_interval_index_begins_at_0
    @hill_climb.send(:prepare_search)
    @hill_climb.send(:prepare_each_run)
    assert_equal 0, @hill_climb.interval_index
  end
  
  def test_that_current_cost_begins_at_cost_of_start_point
    @hill_climb.send(:prepare_search)
    @hill_climb.send(:prepare_each_run)
    
    assert_equal @hill_climb.send(:get_cost, @start_vector), @hill_climb.instance_variable_get(:@current_cost)
  end
  
  def test_that_prepare_each_run_sets_initial_run_to_false
    @hill_climb.send(:prepare_search)
    assert @hill_climb.initial_run, "@initial_run should be true initially"
    @hill_climb.send(:prepare_each_run)
    refute @hill_climb.initial_run, "@initial_run should be false after run is prepared"
  end
  
  def test_that_jump_back_decreases_path_size
    @hill_climb.path = [1,2,3]
    path_size_before = @hill_climb.path.size
    @hill_climb.send(:jump_back)
    assert_operator path_size_before, :>, @hill_climb.path.size
  end
  
  def test_that_jump_back_changes_current_point_to_most_recent
    @hill_climb.path = [1,2,3]
    @hill_climb.send(:jump_back)
    assert 3, @hill_climb.current_point
  end
  
  def test_that_jump_back_increases_banned_points_size_by_1
    @hill_climb.banned_points = {}
    @hill_climb.path = [[2,4,5], [4,5,6]]
    @hill_climb.send(:jump_back)
    assert_equal 1, @hill_climb.banned_points.size
  end
  
  def test_that_jump_back_adds_current_point_to_banned_points
    @hill_climb.banned_points = {}
    @hill_climb.path = [[2,4,5], [4,5,6]]
    @hill_climb.send(:jump_back)
    assert_includes @hill_climb.banned_points, [4,5,6].hash
  end
end