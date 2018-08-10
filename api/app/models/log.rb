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

  def self.first_status(component_name)
    sql = <<-SQL
      SELECT DISTINCT
        logs.component_name,
        logs.component_type,
        logs.location,
        logs.status,
        logs.change_ts
      FROM logs
      INNER JOIN (
        SELECT logs.component_name, MIN(logs.change_ts) AS min_change_ts FROM logs WHERE logs.component_name = ? GROUP BY logs.component_name
      )min
      ON logs.component_name = min.component_name
      AND logs.change_ts = min.min_change_ts
      WHERE
        logs.component_name = ?
    SQL

    Log.find_by_sql [sql, component_name, component_name]
  end

  def self.last_status(component_name)
    sql = <<-SQL
      SELECT DISTINCT
        logs.*
      FROM logs
      INNER JOIN (
        SELECT logs.component_name, MAX(logs.change_ts) AS max_change_ts FROM logs WHERE logs.component_name = ? GROUP BY logs.component_name
      )max
      ON logs.component_name = max.component_name
      AND logs.change_ts = max.max_change_ts
      WHERE
        logs.component_name = ?
    SQL

    Log.find_by_sql [sql, component_name, component_name]
  end

  def self.mean_completition_time_by_component_type
    sql = <<-SQL
      SELECT DISTINCT
        logs.component_type,


    SQL

  end

  def self.convert_ms_to_datetime(ms)
    Time.at(ms/1000)
  end




end
