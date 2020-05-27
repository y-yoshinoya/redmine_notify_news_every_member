require_dependency 'news'

module NotifyNewsPatch
  def notified_users
    notified = project.users
    notified.select {|user| visible?(user)}
  end
end

ActiveSupport::Reloader.to_prepare do
  unless News.included_modules.include?(NotifyNewsPatch)
    News.prepend(NotifyNewsPatch)
  end
end
