class CompanyCodesController < ApplicationController
  unloadable
  before_filter :find_project

  def create
    company_code = CompanyCode.new(company_code_params)
    company_code.save
    redirect_to project_supports_new_path(@project)
  end

	def destroy
    company_code = CompanyCode.find(params[:id])
    company_code.destroy
    redirect_to project_supports_new_path(@project)
	end

  private
  def company_code_params
      params.require(:company_code).permit(:code, :domain)
  end

  def find_project
    @project = Project.find(params[:project_id])
  end
end
