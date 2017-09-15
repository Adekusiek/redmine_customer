module Exceltodb
  def self.sixteen
    xlsm = Roo::Spreadsheet.open('//10.1.1.100/public/FSI/10_CustomerSupport/99_OldVer/CS_Master_backup/CS2016JP_Master_new_mod.xlsm')
    sheet_names = xlsm.sheets
    sheet_names.each do |sheet_name|
      next unless sheet_name.include? "CS2016"
      sheet = xlsm.sheet(sheet_name)
      if  sheet_name[8..10].to_i < 68
       row = 13
       set_issue_journal(row, sheet, sheet_name)

      else
        row = 18
        issue = set_issue_journal(row, sheet, sheet_name)

          customer = Customer.find_by(email: sheet.cell(13, 3))
          if customer
            IssueCustomer.create({
              issue_id: issue.id,
              customer_id: customer.id,
              license_id: 0
              })
          end
      end

      break if sheet_name[8..10].to_i > 70
    end

  end

  def self.set_issue_journal(row, sheet, sheet_name)
    issue = Issue.create({
                tracker_id: 1,
                project_id: 1,
                subject: sheet_name,
                description: sheet.cell(row, 3),
                due_date: "2016-12-31",
                status_id: 1,
                assigned_to_id: 1,
                priority_id: 2,
                author_id: 1,
                lock_version: 1,
                start_date: "2016-01-01",
                done_ratio: 100,
                lft: 1,
                rgt: 2,
                is_private: 0
            })

      row += 1
      while sheet.cell(row, 3)  do
        comment =  ""
        if sheet.cell(row, 4)
          comment = "From #{sheet.cell(row, 4)} \n\n" + sheet.cell(row, 3)
        else
          comment = sheet.cell(row, 3)
        end

        Journal.create({
          journalized_id: issue.id,
          journalized_type: "Issue",
          user_id: 1,
          notes: comment
          })
        row +=1
      end

      return issue
  end
end

Exceltodb.sixteen
