class EnquetesController < ApplicationController
  unloadable

  def index
    @project = Project.find(params[:project_id])
    @enquetes =  Enquete.where(project_id: @project.id).order(issue_id: "ASC").includes(:customer, :issue).page(params[:page])
  end

  def accept_enquete
    customer = Customer.find(params[:id])
    customer.update(accept_flag: true)
    redirect_to :back
  end

  def refuse_enquete
    customer = Customer.find(params[:id])
    customer.update(accept_flag: false)
    redirect_to :back
  end

  def set_reply
      enquete = Enquete.find(params[:id])
      enquete.update(recieved_flag: true)
      enquete.customer.update(last_reply_date: Date.today)
      redirect_to :back
  end

  private

 end
