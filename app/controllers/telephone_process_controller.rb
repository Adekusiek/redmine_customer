class TelephoneProcessController < ApplicationController
  unloadable

  def index
    @project = Project.find(params[:project_id])

    @q = Customer.ransack(params[:q])
    @customers = if params[:q]
      @q.result(distinct: true)
    else
      nil
    end

    return @license = nil if !params[:license] #first access to index page
    license_number = if params[:license][:license_number]
      params[:license][:license_number].to_s.tr("０-９", "0-9")
    else
      ""
    end
    search_str = params[:license][:CM_category] + "-" + license_number
    @license = License.find_by(license_num: search_str)
    @nil_flag = true if @license.nil?


  end

  def search
    index
    render :index
  end

  private

 end
