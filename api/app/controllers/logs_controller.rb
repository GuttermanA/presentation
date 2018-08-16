class LogsController < ApplicationController
  def index
    manufacturing_process_by_component_type = Log.manufacturing_process_by_component_type
    render json: manufacturing_process_by_component_type
  end
end
