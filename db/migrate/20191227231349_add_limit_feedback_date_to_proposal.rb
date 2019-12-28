class AddLimitFeedbackDateToProposal < ActiveRecord::Migration[5.2]
  def change
    add_column :proposals, :limit_feedback_date, :date
  end
end
