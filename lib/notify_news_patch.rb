require_dependency 'news'

module NotifyNewsPatch
  def self.included(base)
    base.send(:include, WrapperMethods)
    
    base.class_eval do
      alias_method_chain :notified_users, :patch
    end
  end

  module WrapperMethods
    def notified_users_with_patch
      notified = project.users  # original: project.notified_users
      notified.select {|user| visible?(user)}
    end
  end
end

News.send(:include, NotifyNewsPatch)
