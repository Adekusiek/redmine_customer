module Supports
	module IssuePatch


		def show_auto_close_btn
			self.auto_close_flag ? "クローズメールを送らない" : "クローズメールを送る"
		end

		def update_new_to_answer
			if self.status.name == "New"
				self.status = IssueStatus.find_by(name: "Answered")
				self.save
			end
		end
  end
end
