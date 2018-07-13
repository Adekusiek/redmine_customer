class Enquete < ActiveRecord::Base
  unloadable
  belongs_to :customer
  belongs_to :issue
  belongs_to :customer_enquete

  def show_enquete_status
    if self.sent_date < Date.new(2016, 12, 31)
      "送信スキップ"
    else
      "送信済み"
    end
  end
end
