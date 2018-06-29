class LicensesController < ApplicationController
  unloadable

  def index
    @project = Project.find(params[:project_id])
    return @license = nil if !params[:session] #first access to index page
    license_number = if params[:session][:license_number]
      params[:session][:license_number].to_s.tr("０-９", "0-9")
    else
      ""
    end
    search_str = params[:session][:CM_category] + "-" + license_number
    @license = License.find_by(license_num: search_str)
    @nil_flag = true if @license.nil?
  end

  private

 end
