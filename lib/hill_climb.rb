# Performs a hill-climb search using all adjacent points
class HillClimb
  attr_accessor :path, :goal_vector, :start_vector, :current_point, :debug_level
  
  def initialize start_vector, goal_vector, options = {}
    @debug_level        = options[:debug_level]     || 1
    @epsilon            = options[:epsilon]         || 0.01
    @max_iterations     = options[:max_iterations]  || 1000
    @banned_points      = options[:banned_points]   || {}
  end
  
  def search
    prepare_search
    catch :success do
      # Main iteration loop
      @max_iterations.times do |iteration|
        begin #RuntimeError rescue block
        end
      end
    end
  end
end