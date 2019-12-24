class AddClosedFeedbackToRegistereds < ActiveRecord::Migration[5.2]
  def change
    add_column :registereds, :closed_feedback, :text
  end
end
