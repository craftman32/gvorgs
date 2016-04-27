class ContactMailer < ApplicationMailer
	default from: 'mike@orgsink.com'
 
	def contact_email(first_name, last_name, subject, message)
		@first_name = first_name
		@last_name = last_name
		@subject = subject
		@message = message
		mail(to: "webteam@gvsu.edu", subject: @subject)
	end
end
