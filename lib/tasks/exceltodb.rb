module Exceltodb

  def self.sixteen
    xlsm = Roo::Spreadsheet.open('//10.1.1.100/public/FSI/10_CustomerSupport/99_OldVer/CS_Master_backup/CS2016JP_Master_new_mod.xlsm')
    sheet_names = xlsm.sheets
    sheet_names.each do |sheet_name|
      next unless sheet_name.include? "CS2016"
      sheet = xlsm.sheet(sheet_name)
      if  sheet_name[8..10].to_i < 68
       row = 13
       set_issue_journal_simple(row, sheet, sheet_name)

      else
        row = 18
        issue = set_issue_journal_simple(row, sheet, sheet_name)

          customer = Customer.find_by(email: sheet.cell(13, 3))
          if customer
            IssueCustomer.create({
              issue_id: issue.id,
              customer_id: customer.id,
              license_id: 0
              })
          end
      end
    end

  end

  def self.set_issue_journal_simple(row, sheet, sheet_name)
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


  def self.seventeen
    xlsm = Roo::Spreadsheet.open('C:/Users/kek/Desktop/CS2017JP_Master_new.xlsm')
    sheet_names = xlsm.sheets
    sheet_names.each do |sheet_name|
      next unless sheet_name.include? "CS2017"
      sheet = xlsm.sheet(sheet_name)
      colomun = 0
      if  sheet_name[8..10].to_i < 288
       colomun = 7
      else
       colomun = 6
      end
      issue = set_issue_journal_complex(sheet, sheet_name, colomun)

      customer = Customer.find_by(email: sheet.cell(13, 3))
      license = License.find_by(license_num: sheet.cell(7, 3)) unless sheet.cell(7, 3) == "-"
      license = 0 if !license

      if customer
        IssueCustomer.create({
          issue_id: issue.id,
          customer_id: customer.id,
          license_id: license
          })

        master_row = sheet_name[8..10].to_i + 3
        recieved_flag = false

        master_sheet = xlsm.sheet("Master")

        if master_sheet.cell(master_row, 'Q')
          customer.customer_enquete.update(last_reply_date: master_sheet.cell(master_row, 17))
          recieved_flag = true
        end

        if master_sheet.cell(master_row, 'P') != nil && issue.done_ratio == 100

          sent_date = ""
          if master_sheet.cell(master_row, 'P').kind_of?(Date)
            sent_date = master_sheet.cell(master_row, 'P')
          else
            sent_date = issue.due_date.prev_year
          end

          Enquete.create!({
            sent_date: sent_date,
            customer_id: customer.id,
            issue_id: issue.id,
            project_id: 1,
            customer_enquete_id: customer.customer_enquete.id,
            recieved_flag: recieved_flag
            })
        end

      end

      break if sheet_name[8..10].to_i > 5
    end

  end

  def self.set_issue_journal_complex(sheet, sheet_name, colomun)
    start_date = sheet.cell(18, 5)
    status_id = 1
    done_ratio = 0
    case sheet.cell(4,3)
    # when "Closed" then
    #   status_id = 5
    #   done_ratio = 100
    # when "Investigation (domestic)" then
    #   status_id =2
    # when "Request support to GmbH" then
    #   status_id =10
    # when "Open" then
    #   status_id = 1
    # when "Clarifying by customer" then
    #   status_id = 11
    # when "Closing confirmation to customer" then
    #   status_id = 4
    # end
  when "Closed" then
    status_id = 5
    done_ratio = 100
  when "Investigation (domestic)" then
    status_id = 2
  when "Request support to GmbH" then
    status_id = 3
  when "Open" then
    status_id = 1
  when "Clarifying by customer" then
    status_id = 4
  when "Closing confirmation to customer" then
    status_id = 6
  end

    assigned_to_id = author_id = set_user_id(sheet.cell(9, 3))

    issue = Issue.create({
                tracker_id: 1,
                project_id: 1,
                subject: sheet_name,
                description: sheet.cell(18, 3),
                status_id: status_id,
                assigned_to_id: assigned_to_id,
                priority_id: 2,
                author_id: author_id,
                lock_version: 1,
                start_date: start_date,
                done_ratio: done_ratio,
                lft: 1,
                rgt: 2,
                is_private: 0
            })

      row = 18
      while sheet.cell(row, 3)  do
        row +=1
        comment =  ""
        if sheet.cell(row, 4)
          comment = "From #{sheet.cell(row, 4)} \n\n" + sheet.cell(row, 3)
        else
          comment = sheet.cell(row, 3)
        end

        Journal.create({
          journalized_id: issue.id,
          journalized_type: "Issue",
          user_id: author_id,
          notes: comment
          })

        if sheet.cell(row, colomun) && set_user_id(sheet.cell(row, 4)) != 0
          user = User.find_by(set_user_id(sheet.cell(row, 4)))
          time_entry = TimeEntry.new
          time_entry.project = issue.project
          time_entry.issue = issue
          time_entry.user = user
          time_entry.spent_on = sheet.cell(row, 5)
          time_entry.activity_id = 8
          time_entry.hours = sheet.cell(row, colomun)
          time_entry.save
        end
      end
      due_date = sheet.cell(row - 1, 5)
#      end_datetime = due_date + " 23:59:59"
#      issue.update(updated_on: end_datetime, due_date: due_date)
      issue.update(closed_on: due_date.to_datetime, due_date: due_date)

      return issue
  end

  def self.set_user_id(staff_code)
    user_id = 0
    case staff_code
    # when "tem" then
    #   user_id = 7
    # when "alm" then
    #   user_id = 5
    # when "hit" then
    #   user_id = 1
    # when "yug" then
    #   user_id = 9
    # when "kek" then
    #   user_id = 10
    # when "hik" then
    #   user_id = 11
    # end
  when "tem" then
    user_id = 6
  when "alm" then
    user_id = 10
  when "hit" then
    user_id = 8
  when "yug" then
    user_id = 9
  when "kek" then
    user_id = 5
  when "hik" then
    user_id = 7
  end
      return user_id
  end
end

#Exceltodb.sixteen
Exceltodb.seventeen
