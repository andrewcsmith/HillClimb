# Subclasses of HillClimb should perform a HillClimb search
# 
# == Requirements for subclassing:
# 
# [+:get_cost+]             Cost function for a given candidate
# [+:get_candidate_list+]   Returns a sorted list of all possible candidates
# 
class HillClimb
  attr_accessor :path, :goal_vector, :start_vector, :current_point, :debug_level, :epsilon, :max_iterations, :banned_points
  
  ##
  # Requires the +start_vector+ and +goal_vector+. Does not necessarily have to
  # specifically be a vector, but could also be any object as long as the 
  # function +:get_cost+ knows how to respond to it.
  
  def initialize start_vector, goal_vector, options = {}
    @debug_level        = options[:debug_level]     || 1
    @epsilon            = options[:epsilon]         || 0.01
    @max_iterations     = options[:max_iterations]  || 1000
    @banned_points      = options[:banned_points]   || {}
    @start_vector       = start_vector
    @goal_vector        = goal_vector
  end
  
  ##
  # Main skeleton for iterating over the loop. There are callbacks at various
  # points that allow a subclass to overwrite or extend the default 
  # functionality, which attempts to be as minimal as possible.
    
  def search
    prepare_search
    catch :success do
      # Main iteration loop
      @max_iterations.times do |iteration|
        begin # RuntimeError rescue block
          # At the start of each iteration
          prepare_each_run
          if @banned_points.has_key?(path.last) && path.size == 1
            throw :success
          end
          debug_each_iteration iteration
          going = catch :keep_going do
            message = catch :jump_back do
              # cost_vector is a list of all adjacent points with their 
              # respective costs
              candidate_list = get_candidate_list
              begin # IndexError rescue block
                # If we've run out of all possible points, step back and keep 
                # trying. Only works when candidate_list#size is the largest
                # dimension, i.e., for a normal Array of NArrays. For NArray, 
                # #size gives the total number of elements.
                if @interval_index >= candidate_list.size 
                  throw :jump_back, "index #{@interval_index} is out of range"
                end
                # Load up the candidate from the cost_vector
                candidate = candidate_list[@interval_index]
                candidate_cost = get_cost candidate
                # Skip all candidates that are banned, are already in the path, 
                # or don't get us any closer.
                while (@banned_points.has_key? candidate.hash) || (@path.include? candidate) || (candidate_cost >= @current_cost)
                  @interval_index += 1
                  # If we've exhausted all possible intervals, jump back
                  if @interval_index >= candidate_list.size
                    @banned_points[candidate.hash] = 1
                    throw :jump_back, "index #{@interval_index} is out of range"
                  end
                  # Get the movement that is at the current index
                  candidate = candidate_list[@interval_index]
                  candidate_cost = get_cost candidate
                end
                # Add it to the path!
                @path << candidate
                @current_cost = candidate_cost
              rescue IndexError => er
                puts "\nIndexError: #{er.message}"
                print er.backtrace.join("\n")
                throw :jump_back
              rescue RangeError => er
                # If handle_range_error has not been defined in a subclass, any 
                # call will just re-raise the exception
                handle_range_error er
              end
              # Judge success
              if @current_cost < @epsilon
                @current_point = @path.last
                prepare_result
                throw :success
              else
                @initial_run = true
                throw :keep_going, true
              end
            end # catch :jump_back
            if @debug_level > 1
              puts message
            end
            jump_back
          end # catch :keep_going
          if going
            keep_going
            going = false
          end
        rescue RuntimeError => er
          puts "\n#{er.message}"
          print er.backtrace.join("\n")
          print "\n\nPath: #{@path.to_a}\n"
          break
        end #RuntimeError block
      end # main iteration loop
    end # catch :success
    debug_final_report
    prepare_data
    @data
  end
  
  private
  
  ##
  # To extend: Should return the cost for a given candidate
  
  def get_cost candidate
    raise NoMethodError, 'get_cost should be defined in subclass of HillClimb'
  end
  
  ##
  # To extend: Should return a list of adjacent points (could be all points in a
  # space), sorted by cost.
    
  def get_candidate_list
    raise NoMethodError, 'get_candidate_list should be defined in subclass of HillClimb'
  end
  
  ## 
  # Should conform to the default behavior outlined in the test suite
  
  def prepare_search
    # puts "prepare_search called"
    @current_point = @start_vector
    @interval_index = 0
    @path = [@start_vector]
    @initial_run = true
    
    @current_cost = get_cost @current_point
  end
  
  ##
  # Outputs the play-by-play
  
  def debug_each_iteration iteration
    case
    when @debug_level > 1
      puts "Iteration #{iteration}"
      puts "Now #{@current_cost} away at #{@current_point.inspect}"
    when @debug_level > 0
      print "\t\t\t\t\t\rIteration #{iteration}: #{@current_cost} away"
    end
  end
  
  ##
  # Outputs the results of the search
  
  def debug_final_report
    case
    when @debug_level > 0
      puts "\nSuccess at: \t#{@current_point.to_a}"
      ptus "Cost: \t\t#{@current_cost}"
    end
  end
  
  ##
  # Callback for when backtracking on the search path is necessary
  
  def jump_back
    @banned_points[@path.last.hash] = @path.pop
    @current_point = @path.last || (@path << @start_vector).last
    @current_cost = get_cost @current_point
    @banned_points.delete @start_vector.hash
    @initial_run = true
    if @debug_level > 1
      puts "Jumping back"
      puts "Banning #{@banned_points.last.inspect}"
    end
  end
  
  ##
  # Before each run, checks to see if it's the initial run
  
  def prepare_each_run
    # puts "prepare_each_run called"
    if @initial_run
      @interval_index = 0
      @initial_run = false
    end
  end
  
  ## 
  # Packs the resulting path, final cost, and list of banned points into a 
  # +Hash+
  
  def prepare_data
    @data = {
      :banned_points => @banned_points,
      :cost => @current_cost,
      :path => @path
    }
    if @current_cost > @epsilon
      @data[:failed] = true
    end
  end
  
  ##
  # Callback for when a point is added successfully to the path
  
  def keep_going; end
  
  ##
  # Callback for when a correct result is found
  
  def prepare_result; end
  
  ##
  # Error handler for when the call is out of range. If this is not subclassed, 
  # it just re-raises the error.
  
  def handle_range_error er; raise er; end
end