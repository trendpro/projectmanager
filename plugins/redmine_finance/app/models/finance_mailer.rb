class FinanceMailer < Mailer
  helper :deals

  def account_edit(operation)
    @account = operation.account.reload
    redmine_headers 'Project' => @account.project.identifier,
                    'Account-Id' => @account.id
    redmine_headers 'Account-Assignee' => @account.assigned_to.login if @account.assigned_to
    message_id operation
    references @account
    @author = User.current
    recipients = @account.recipients
    # Watchers in cc
    cc = @account.watcher_recipients - recipients
    s = "[#{@account.project.name} - #{@account.name}] - #{@account.amount_to_s}"
    @operation = operation
    @account_amount_was = @account.account_amount_was
    @operation_url = url_for(:controller => 'operations', :action => 'show', :id => @operation)
    mail :to => recipients,
      :cc => cc,
      :subject => s
  end  
end
