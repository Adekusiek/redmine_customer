class UpdateIssues
  def self.update_issue_customers

    issue_customers = IssueCustomer.all.includes(:issue)
    ActiveRecord::Base.transaction do
      issue_customers.each do |issue_customer|
        issue = issue_customer.issue
        next if issue.nil?
        issue.update_columns(
          customer_id: issue_customer.customer_id,
          license_id: issue_customer.license_id
        )
      end
    end
  end

  def self.update_enquetes

    enquetes = Enquete.all.includes(:issue)
    ActiveRecord::Base.transaction do
      enquetes.each do |enquete|
        issue = enquete.issue
        next if issue.nil?
        issue.update_columns(
          enquete_id: enquete.id,
        )
      end
    end
  end
end


UpdateIssues.update_issue_customers
# UpdateIssues.update_enquetes
