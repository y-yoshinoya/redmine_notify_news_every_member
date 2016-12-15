require_dependency 'news'

module NotifyNewsPatch
  def self.included(base)
    base.send(:include, WrapperMethods)

    base.class_eval do
      alias_method_chain :notified_users, :patch
      alias_method_chain :send_notification, :patch
    end
  end

  module WrapperMethods
    def notified_users_with_patch
      notified = project.users  # original: project.notified_users
      notified.select {|user| visible?(user)}
    end

    def send_notification_with_patch
      if Setting.notified_events.include?('news_added')
        mail = Mailer.news_added(self)
        all_addresses = mail.to + mail.cc + mail.bcc
        all_addresses.uniq.each_slice(50).each.with_index do |addresses, index|
          m = mail.dup
          m.message_id = m.message_id.gsub(/@/, "#{index}@")
          m.to = []
          m.cc = []
          m.bcc = addresses
          m.deliver
        end
      end
    end
  end
end

News.send(:include, NotifyNewsPatch)
