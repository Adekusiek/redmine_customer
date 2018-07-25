
module UpdateDb
  def self.update_customer
    xlsm = Roo::Spreadsheet.open('//10.1.1.100/Data/share/01_Opportunity/IPG-J_Opportunity_all.xlsx')
    mysheet = xlsm.sheet('Customer')
    i = 0
    mysheet.column(1).each do |email|
      i += 1
      next if i < 3 || !email
      # customer = Customer.where(email: email).first_or_create
      # customer.update({
      #   family_name: mysheet.cell(i, 5),
      #   given_name:  mysheet.cell(i, 3),
      #   title:       mysheet.cell(i, 6),
      #   company:     mysheet.cell(i, 7),
      #   dept:        mysheet.cell(i, 8)
      #      })
      customer = Customer.find_by(email: email)
      if customer
          customer.update({
            family_name: mysheet.cell(i, 5),
            family_name_alphabet: mysheet.cell(i,79),
            given_name:  mysheet.cell(i, 3),
            given_name_alphabet:  mysheet.cell(i, 94),
            title:       mysheet.cell(i, 6),
            company:     mysheet.cell(i, 7),
            dept:        mysheet.cell(i, 8)
               })
      else
        customer = Customer.new({
          email:       email,
          family_name: mysheet.cell(i, 5),
          family_name_alphabet: mysheet.cell(i,79),
          given_name:  mysheet.cell(i, 3),
          given_name_alphabet:  mysheet.cell(i, 94),
          title:       mysheet.cell(i, 6),
          company:     mysheet.cell(i, 7),
          dept:        mysheet.cell(i, 8)
             })
        customer.build_customer_enquete
        customer.save
      end
    end
  end

  def self.update_license
    xlsx = Roo::Spreadsheet.open('//10.1.1.100/Data/share/11_License/IPG_Automotive_KK_License.xlsx')
    # self.check_license_sheet(customer_sheet)
    # deactivated sheet contains abondoned license information(invalid), but customer sheet lists the same license number categorized(valid)
    # give priority to customer sheet and override
    deactivate_sheet = xlsx.sheet('Deactivate')
    self.scan_license(deactivate_sheet)

    customer_sheet = xlsx.sheet('Customer')
    self.scan_license(customer_sheet)
  end

  def self.scan_license(sheet)
    i = 0
    sheet.column(3).each do |license_num|
      i += 1
      next if i < 3 || !license_num
      license = License.where(license_num: license_num).first_or_create
      status = hil_flag = 0
      hil_type_id = nil
      status = 1 if sheet.cell(i, 7).to_s == "valid"

      license_type = sheet.cell(i, 4).to_s

      license_code_split = sheet.cell(i, 9).to_s.split('-')
      license_code_first = license_code_split[0]
      license_code_first ||= ""

      # we do not care if it is concerto license
      if license_code_first.last == "H"
        hil_flag = true
        # FIXME: This part must be updated in the future
        # Current license file does not have the identifier
        hil_type_id = if license_code_split[2].include?("DS")
          2
        elsif license_code_split[2].include?("LC")
          3
        elsif license_code_split[2].include?("X")
          4
        elsif license_code_split[2].include?("NI")
          5
        else
          1
        end
      end

      license.update(status: status, hil_type_id: hil_type_id, hil_flag: hil_flag, license_type: license_type)
    end
  end

end


UpdateDb.update_customer
UpdateDb.update_license
