
module AutoCloser
  def self.send_new_status_warning
    new_id = IssueStatus.find_by(name: "New")
    issues = Issue.where("updated_on < ? and status_id = ?", \
            1.day.ago, new_id)

    issues.each do |issue|
      # skip if the project is not Customer support children or older than 2018
      next unless issue.project.parent_id == 3 && issue.project.id > 18
      AutoCloseMailer.new_status_warning(issue).deliver
    end
  end

  def self.send_close_confirmation

    answered = IssueStatus.find_by(name: "Answered")
    issues = Issue.where(updated_on: 28.day.ago..14.day.ago, status_id: answered.id, auto_close_flag: true)

    issues.each do |issue|
      # skip if the project is not Customer support project children or older than 2018
      next unless issue.project.parent_id == 3 && issue.project.id > 18

      issue_customer = IssueCustomer.find_by(issue_id: issue.id)
      return if !issue_customer || !issue_customer.customer

      AutoCloseMailer.close_confirmation(issue, issue_customer.customer).deliver
      # NOTE: update_column does not touch timestamp
      issue.update_column(:auto_close_flag, false)
    end
  end

  def self.close_issues

    answered = IssueStatus.find_by(name: "Answered")
    closed = IssueStatus.find_by(name: "Closed")

    issues = Issue.where("updated_on < ? and status_id = ?", 18.day.ago, answered.id)

    issues.each do |issue|
      next unless issue.project.parent_id == 3 && issue.project.id > 18
      issue.status = closed
      issue.save
    end
  end
end

AutoCloser.send_new_status_warning
AutoCloser.send_close_confirmation
AutoCloser.close_issues
