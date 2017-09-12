module Files
  module AttachmentPatch
    def files_to_final_location
      if @temp_file
        logger.info("I'm called in attachment patch") if logger
      end

      super

      # original = self.diskfile
      # puts original
      # puts self.container_id
      # issue = Issue.find(self.container_id)
      # dir = "//10.1.1.100/public/FSI/10_CustomerSupport/test/#{issue.subject}/"
      # FileUtils.cp(original, dir)
    end
  end
end
