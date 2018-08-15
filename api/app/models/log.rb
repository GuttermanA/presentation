class Log < ApplicationRecord
  include Helper
  before_create :unique_log_entry

  def unique_log_entry
    !!!Log.find_by(
      component_name: self.component_name,
      component_type: self.component_type,
      location: self.location,
      status: self.status,
      change_ts: self.change_ts
    )
  end

  def self.min_and_max_dates

    sql = <<-SQL
      SELECT DISTINCT
        MIN(change_ts) AS min_date,
        MAX(change_ts) AS max_date
      FROM logs
    SQL

    results = Log.find_by_sql [sql]
    [results[0].min_date, results[0].max_date]
  end

  def self.unique_components
    sql = <<-SQL
      SELECT DISTINCT
        logs.component_name,
        logs.component_type
      FROM logs
    SQL

    Log.find_by_sql [sql]
  end

  def self.unique_component_types
    sql = <<-SQL
      SELECT DISTINCT
        logs.component_type
      FROM logs
    SQL

    results = Log.find_by_sql [sql]
    results.map{|x| x.component_type}
  end

  def self.unique_component_types_by_location(location)
    sql = <<-SQL
      SELECT DISTINCT
        logs.component_type
      FROM logs
      WHERE location = ?
    SQL

    results = Log.find_by_sql [sql, location]
    results.map{|x| x.component_type}

  end

  def self.unique_locations
    sql = <<-SQL
      SELECT DISTINCT
        logs.location
      FROM logs
    SQL

    results = Log.find_by_sql [sql]
    results.map{|x| x.location}
  end

  def self.unique_statuses
    sql = <<-SQL
      SELECT DISTINCT
        logs.status
      FROM logs
    SQL

    Log.find_by_sql [sql]
  end

  def self.first_status(component_name = "COMPONENT000000001")
    sql = <<-SQL
      SELECT DISTINCT
        logs.id,
        logs.component_name,
        logs.component_type,
        logs.location,
        logs.status,
        MIN(logs.change_ts) min_change_ts
      FROM logs
      WHERE
        logs.component_name = ?
      GROUP BY logs.component_name
    SQL

    results = Log.find_by_sql [sql, component_name]
    results.map(&:attributes)
  end

  def self.last_status(component_name = "COMPONENT000000001")
    sql = <<-SQL
      SELECT DISTINCT
        logs.id,
        logs.component_name,
        logs.component_type,
        logs.location,
        logs.status,
        MAX(logs.change_ts) max_change_ts
      FROM logs
      WHERE
        logs.component_name = ?
      GROUP BY logs.component_name
    SQL

    results = Log.find_by_sql [sql, component_name]
    results.map(&:attributes)
  end

  def self.minutes_to_completion(component_name = "COMPONENT000000001")
    sql = <<-SQL
      SELECT DISTINCT
        logs.id,
        logs.component_name,
        logs.component_type,
        MIN(logs.change_ts) AS min_change_ts,
        MAX(logs.change_ts) AS max_change_ts,
        (JULIANDAY(MAX(logs.change_ts)) - JULIANDAY(MIN(logs.change_ts))) * 24 * 60 AS minutes_to_completion
      FROM logs
      WHERE
        logs.component_name = ?
      GROUP BY logs.component_name
    SQL

    results = Log.find_by_sql [sql, component_name]
    results.map(&:attributes)
  end

  # BY COMPONENT TYPE

  def self.mean_completion_time_by_component_type(format = "day")

    multiplier = Helper.time_multiplier(format)

    connection = ActiveRecord::Base.connection

    connection.execute("DROP TABLE IF EXISTS temp")

    temp_sql = <<-SQL
      SELECT
        component_name,
        component_type,
        (JULIANDAY(MAX(logs.change_ts)) - JULIANDAY(MIN(logs.change_ts))) * #{multiplier} AS time_to_completion
      FROM logs
      GROUP BY component_name
      HAVING time_to_completion > 0;
    SQL

    connection.create_table(:temp, temporary: true, as: temp_sql)

    sql = <<-SQL
      SELECT
        component_type,
        AVG(time_to_completion) AS avg_completion_minutes
      FROM temp
      GROUP BY component_type;
    SQL


    results = Log.find_by_sql [sql]
    results.map(&:attributes)
  end

  def self.component_steps(component_type = nil)
    # connection = ActiveRecord::Base.connection
    #
    # connection.execute("DROP TABLE IF EXISTS temp")

    # temp_sql = <<-SQL
    # CREATE TEMPORARY TABLE temp (
    #   id INTEGER PRIMARY KEY ASC,
    #   component_name TEXT,
    #   component_type TEXT,
    #   location TEXT,
    #   status TEXT,
    #   change_ts DATETIME
    # );
    #
    # INSERT INTO temp (component_name, component_type, location, status, change_ts)
    #   SELECT
    #   logs.component_name,
    #   logs.component_type,
    #   logs.location,
    #   logs.status,
    #   logs.change_ts
    #   FROM logs
    #   WHERE status IN ("in progress", "complete")
    #   ORDER BY logs.component_name, logs.change_ts;
    #
    # SQL


    # temp_sql = <<-SQL
    #   SELECT DISTINCT
    #     component_name,
    #     component_type,
    #     location,
    #     status,
    #     change_ts
    #   FROM logs
    #   WHERE status IN ("in progress", "complete")
    #   ORDER BY logs.component_name, logs.change_ts;
    # SQL
    #
    # connection.create_table(:temp, temporary: true, as: temp_sql)

    if component_type
      sql = <<-SQL
        SELECT DISTINCT
        *
        FROM logs
        INNER JOIN (
          SELECT DISTINCT
            component_name
          FROM logs
          WHERE component_type = ?
          AND status IN ("in progress", "complete")
          ORDER BY component_name, change_ts;
          LIMIT 1
        ) first
        ON logs.component_name = first.component_name
      SQL

      Log.find_by_sql [sql, component_type]
    else
      sql = <<-SQL
        SELECT DISTINCT
          *
        FROM logs
        WHERE status IN ("in progress", "complete")
        ORDER BY component_name, change_ts;
      SQL

      Log.find_by_sql [sql]
    end
  end

  def self.manufacturing_process_by_component_type
    unique_component_types = Log.unique_component_types
    result = unique_component_types.inject({}) do |obj, component_type|
      obj[component_type] = []
      obj
    end

    unique_component_types.each do |component_type|
      Log.component_steps(component_type).each do |step|
        result[component_type] << step.location
      end
    end
    result
  end



  def self.rate_of_output_per_component_type(format = "day")
    multiplier = Helper.time_multiplier(format)
    dates = Log.min_and_max_dates
    date_diff = (Date.parse(dates[1]) - Date.parse(dates[0])).to_f * multiplier
    sql = <<-SQL
      SELECT DISTINCT
        logs.component_type,
        COUNT(logs.component_name) AS total_components,
        (COUNT(logs.component_type) / ?) AS total_components_per
      FROM logs
      WHERE logs.status = 'complete'
      GROUP BY logs.component_type
    SQL

    results = Log.find_by_sql [sql, date_diff]
    results.map(&:attributes)
  end

  #BY LOCATION

  def self.mean_component_completion_time_by_location(format = "day")
    divisor = Helper.time_divisor(format)

    query_results = Log.component_steps

    result = Log.unique_locations.inject({}) do |obj, location|
      component_types = Log.unique_component_types_by_location(location)
      obj[location] = component_types.inject({}) do |obj, component_type|
        obj[component_type] = []
        obj
      end
      obj
    end

    previous = query_results[0]
    counter = 1


    while counter < query_results.length
      current = query_results[counter]
      if previous.component_name != current.component_name
        previous = query_results[counter]
        counter += 1
        next
      end
      # puts "Current time: #{current.change_ts} location: #{current.location}"
      # puts "Previous time #{previous.change_ts} location: #{previous.location}"
      result[previous.location][previous.component_type] << (current.change_ts - previous.change_ts) / divisor
      previous = query_results[counter]
      counter += 1
    end

    result.each do |location, component|
      component.each do |type, times|
        result[location][type] = times.inject{ |sum, el| sum + el }.to_f / times.size
      end
    end

    result
  end

  def self.average_waiting_time_by_location(format = "day")
    divisor = Helper.time_divisor(format)

    sql = <<-SQL
      SELECT DISTINCT
        *
      FROM logs
      ORDER BY component_name, change_ts
    SQL

    query_results = Log.find_by_sql [sql]

    result = Log.unique_locations.inject({}) do |obj, location|
      component_types = Log.unique_component_types_by_location(location)
      obj[location] = component_types.inject({}) do |obj, component_type|
        obj[component_type] = []
        obj
      end
      obj
    end

    previous = query_results[0]
    counter = 1

    while counter < query_results.length

      if previous.component_name != current.component_name || (previous.component_name == current.component_name && previous.status == current.status)
        previous = query_results[counter]
        counter += 1
        next
      end

      if previous.status == "waiting" && (current.status == "in progress" || current.status == "complete")
        result[current.location][current.component_type] << (current.change_ts - previous.change_ts) / divisor
      end


    end



  end

  def self.unit_output_per(format = "day")

  end

end
