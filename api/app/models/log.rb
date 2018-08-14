class Log < ApplicationRecord

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

    Log.find_by_sql [sql]
  end

  def self.unique_locations
    sql = <<-SQL
      SELECT DISTINCT
        logs.location
      FROM logs
    SQL

    Log.find_by_sql [sql]
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

    Log.find_by_sql [sql, component_name]
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

    Log.find_by_sql [sql, component_name]
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

    Log.find_by_sql [sql, component_name]
  end

  def self.mean_completion_time_by_component_type
    sql = <<-SQL
      DROP TABLE IF EXISTS temp;

      CREATE TEMPORARY TABLE temp AS
      SELECT
        logs.component_name,
        logs.component_type,
        (JULIANDAY(MAX(logs.change_ts)) - JULIANDAY(MIN(logs.change_ts))) * 24 * 60 AS minutes_to_completion
      FROM logs
      GROUP BY logs.component_name
      HAVING minutes_to_completion > 0

      SELECT
    		component_type,
    		AVG(minutes_to_completion) AS avg_completion_minutes
  		FROM temp
  		GROUP BY component_type;
    SQL
  end

  def self.mean_component_completion_time_by_location


  end

  def rate_of_output_per_component_type(format = "min")
    divisor = 1
    if format == "sec"
    else if format == "min"
      divisor =
    else if format == "hour"
      divisor = 24
    end


    start_date = '2018-01-01 00:00:00'
    end_date = '2018-06-01 00:00:20'
    date_diff = (Date.parse('2018-06-01 00:00:20') - Date.parse('2018-01-01 00:00:00')).to_f
    sql = <<-SQL

      SELECT
        logs.component_type,
        COUNT(logs.component_name) AS total_components,
        (COUNT(logs.component_type) / ?)


      FROM logs
      WHERE status = 'complete'

  end






end
