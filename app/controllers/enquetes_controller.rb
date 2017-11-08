class EnquetesController < ApplicationController
  unloadable
#  before_filter :find_project, only: [:index]

  def index
    @project = Project.find(params[:project_id])
    @enquetes =  Enquete.where(project_id: @project.id).order(issue_id: "ASC").includes(:customer, :issue, :customer_enquete).page(params[:page])
  end

  def accept_enquete
    customer_enquete = CustomerEnquete.find(params[:id])
    customer_enquete.update(accept_flag: true)
    redirect_to :back
  end

  def refuse_enquete
    customer_enquete = CustomerEnquete.find(params[:id])
    customer_enquete.update(accept_flag: false)
    redirect_to :back
  end

  def set_reply
      enquete = Enquete.find(params[:id])
      enquete.update(recieved_flag: true)
      enquete.customer_enquete.update(last_reply_date: Date.today)
      redirect_to :back
  end

  private
  # def company_code_params
  #     params.require(:company_code).permit(:code, :domain)
  # end
  #
  #  def find_project
  #    @project = Project.find(params[:project_id])
  #  end
 end
