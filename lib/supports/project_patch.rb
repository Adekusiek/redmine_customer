module Supports
	module ProjectPatch

		def get_csnum
			issue_num = self.issues.count + 1

	    cs_num = if issue_num < 10
	      "00" + issue_num.to_s
	    elsif issue_num < 100
	      "0" + issue_num.to_s
	    else
	      issue_num.to_s
	    end
		end

  end
end
