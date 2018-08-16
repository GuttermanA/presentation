class LogsController < ApplicationController
  def manufacturing_process
    render json: Log.manufacturing_process_by_component_type
  end

  def component_stats
    final = Log.mean_completion_time_by_component_type("day")

    [Log.rate_of_output_per_component_type("day"), Log.waiting_time_stats_by_component(format = "day")].each do |query_result|
      counter = 0
      while counter < query_result.length
        final[counter] = final[counter].merge(query_result[counter])
        counter += 1
      end
    end

    render json: final
    # render json: {
    #   mean_completion_days: Log.mean_completion_time_by_component_type("day"),
    #   produced_per_day: Log.rate_of_output_per_component_type("day"),
    #   unit_output_per_day: Log.unit_output_per("day")
    # }
  end

  def location_stats
    final = Log.mean_component_completion_time_by_location("day")
    [Log.location_simultaneous_capacity,Log.location_simultaneous_capacity,Log.waiting_time_stats_by_location("day")].each do |query_result|
      counter = 0
      while counter < query_result.length
        final[counter] = final[counter].merge(query_result[counter])
        counter += 1
      end
    end
    render json: final
    # render json: {
    #   average_components_completed_per_day: Log.mean_component_completion_time_by_location("day"),
    #   simultaneous_capacity: Log.location_simultaneous_capacity,
    #   capacity_per_day: Log.location_simultaneous_capacity,
    #   waiting_time_stat: Log.waiting_time_stats_by_location("day")
    # }
  end
end
