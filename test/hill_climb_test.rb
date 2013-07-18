require_relative './test_helpers.rb'

# == General Tests
# Should be true generally for HillClimb base class

class TestHillClimb < Minitest::Test
  
  FactoryGirl.find_definitions
  
  def setup
    @hill_climb = FactoryGirl.build(:hill_climb)
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
end