class OperationObserver < ActiveRecord::Observer
  def after_save(operation)
    if Setting.notified_events.include?('finance_account_updated')
      FinanceMailer.account_edit(operation).deliver
    end
  end
end
