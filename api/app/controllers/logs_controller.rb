class LogsController < ApplicationController
  def manufacturing_process
    render json: Log.manufacturing_process_by_component_type
  end

  def component_stats
    final = Log.mean_completion_time_by_component_type("day")

    [
      Log.rate_of_output_per_component_type("day"),
      Log.waiting_time_stats_by_component(format = "day")
    ].each do |query_result|
      query_result.each do |row|
        to_merge = final.find{|x| x["component_type"] == row["component_type"] }
        to_merge.merge!(row)
      end
    end
    
    render json: final
  end

  def location_stats
    final = Log.mean_component_completion_time_by_location("day")
    [
      Log.location_simultaneous_capacity,
      Log.location_simultaneous_capacity,
      Log.waiting_time_stats_by_location("day"),
      Log.rate_of_output_by_location
    ].each do |query_result|
      query_result.each do |row|
        to_merge = final.find{|x| x["location"] == row["location"] }
        to_merge.merge!(row)
      end
    end

    render json: final
  end
end
