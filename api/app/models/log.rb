class Log < ApplicationRecord

  def unique_components
    sql = <<-SQL
      SELECT DISTINCT
        logs.component_name,
        logs.component_type
      FROM logs
    SQL

    Logs.find_by_sql [sql]
  end

  def unique_component_types
    sql = <<-SQL
      SELECT DISTINCT
        logs.component_type
      FROM logs
    SQL

    Logs.find_by_sql [sql]
  end

  def unique_locations
    sql = <<-SQL
      SELECT DISTINCT
        logs.location
      FROM logs
    SQL

    Logs.find_by_sql [sql]
  end

  def unique_statuses
    sql = <<-SQL
      SELECT DISTINCT
        logs.status
      FROM logs
    SQL

    Logs.find_by_sql [sql]
  end

  def mean_completition_time_by_component_type
    sql = <<-SQL
      SELECT DISTINCT
        logs.component_type,
        

    SQL

  end




end
