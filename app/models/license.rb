class License < ActiveRecord::Base
  unloadable
  has_many :issue_customers

  # NOTE: hil_typeにてHILの種類を設定したが、いらない
  def show_hil_type_description
    return unless self.hil_flag
    case self.hil_type_id
    when 1
      "不明"
    when 2
      "dSpace"
    when 3
      "Lab Car"
    when 4
      "CarMaker Xeno"
    when 5
      "National Instruments"
    end
  end

  def show_office_or_hil
    if self.hil_flag
      "HIL"
    else
      "Office"
    end
  end

end
