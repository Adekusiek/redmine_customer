module Supports
	module MailHandlerPatch

		private

		ENQUETE_AUTO_REPLY = %r{.*CarMaker\sSupport\sEnquete.*\[(?:[^\]]*\s+)?#(\d+)\]}
		CREATE_ISSUE = /.*CREATE_ISSUE.*/
		MESSAGE_ID_RE = %r{^<?redmine\.([a-z0-9_]+)\-(\d+)\.\d+(\.[a-f0-9]+)?@}
		ISSUE_REPLY_SUBJECT_RE = %r{\[(?:[^\]]*\s+)?#(\d+)\]}
		MESSAGE_REPLY_SUBJECT_RE = %r{\[[^\]]*msg(\d+)\]}

		def dispatch
	    headers = [email.in_reply_to, email.references].flatten.compact
	    subject = email.subject.to_s
			# do not accept 2 byte character for ticket number identification
			subject = subject.tr("０-９", "0-9").tr("＃", "#").tr("「", "\[").tr("」", "\]")
	    if headers.detect {|h| h.to_s =~ MESSAGE_ID_RE}
	      klass, object_id = $1, $2.to_i
	      method_name = "receive_#{klass}_reply"
	      if self.class.private_instance_methods.collect(&:to_s).include?(method_name)
	        send method_name, object_id
	      else
	        # ignoring it
	      end
			elsif m = subject.match(ENQUETE_AUTO_REPLY)
				receive_enquete_reply(m[1].to_i)
			elsif m = subject.match(CREATE_ISSUE)
				receive_create_issue
	    elsif m = subject.match(ISSUE_REPLY_SUBJECT_RE)
				receive_issue_reply(m[1].to_i)
	    elsif m = subject.match(MESSAGE_REPLY_SUBJECT_RE)
				receive_message_reply(m[1].to_i)
	    else
	      dispatch_to_default
	    end
	  rescue ActiveRecord::RecordInvalid => e
	    # TODO: send a email to the user
	    logger.error "MailHandler: #{e.message}" if logger
	    false
	  rescue MissingInformation => e
	    logger.error "MailHandler: missing information from #{user}: #{e.message}" if logger
	    false
	  rescue UnauthorizedAction => e
	    logger.error "MailHandler: unauthorized attempt from #{user}" if logger
	    false
	  end

		# Send automatic reply to someone replied to enquete
	  def receive_enquete_reply(issue_id, from_journal=nil)
	    issue = Issue.find_by_id(issue_id)
	    return unless issue
	    # check permission
	    unless handler_options[:no_permission_check]
	      unless user.allowed_to?(:add_issue_notes, issue.project) ||
	               user.allowed_to?(:edit_issues, issue.project)
	        raise UnauthorizedAction
	      end
	    end
			enquete = Enquete.find_by(issue_id: issue_id)
			return if enquete.recieved_flag == 1
			enquete.update(recieved_flag: true)
			enquete.customer_enquete.update(last_reply_date: Date.today)

			#Mailer
			EnqueteReplyMailer.enquete_send_mailer(issue, enquete.customer).deliver
	  end

		# Deliver ticket number
	  def receive_create_issue
			identifier = "cs" + Date.today.year.to_s + "jp"
			project = Project.find_by(identifier: identifier)
#			project = target_project
	    # check permission
	    unless handler_options[:no_permission_check]
	      raise UnauthorizedAction unless user.allowed_to?(:add_issues, project)
	    end


			email = extract_keyword!(cleaned_up_text_body, :email).split("<mailto")[0].strip
			license = extract_keyword!(cleaned_up_text_body, :license).strip

			customer = Customer.find_by(email: email)

			# if no customer is attached to the email, create new customer and customer_enquete to save the date of last reply and preference of receiving mail
	    unless customer
	      customer = Customer.new(email: email)
	      customer.build_customer_enquete
	      customer.save
	    end
			# give cs number
	    issue_num = project.issues.count + 1

	    if issue_num < 10
	      issue_num = "00" + issue_num.to_s
	    elsif issue_num < 100
	      issue_num = "0" + issue_num.to_s
	    else
	      issue_num = issue_num.to_s
	    end
	    subject_header = "CS" + Date.today.year.to_s + "JP" + issue_num

			# search company code from email
	    domain = email.split("@")[1]
	    company_code = "XXX"
	    company_code = CompanyCode.find_by(domain: domain).code if CompanyCode.find_by(domain: domain)

	    issue = Issue.create({
	                project: project,
	                subject: subject_header + "(" + company_code + ")",
	                description: cleaned_up_text_body,
	                assigned_to: user,
	                tracker_id: 3,
	                author: user,
	                start_date: Date.today
	      })

			# check license status
	    license_id = 0
	    if license
	      license_obj = License.find_by(license_num: license)
	      license_id = license_obj.id  if license_obj
	    end

	    IssueCustomer.create({
	                issue_id: issue.id,
	                customer_id: customer.id,
	                license_id: license_id
	      })

			#Mailer
			PublishTicketMailer.send_mailer(issue).deliver

	    logger.info "MailHandler: issue ##{issue.id} created by #{user}" if logger
	    issue
	  end

  end
end
