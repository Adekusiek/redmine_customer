module Supports
	module MailHandlerPatch
		def dispatch_to_default
        # disable a function which create new issue from receiving mails
        super
		end
  end
end
