class AddFeedbackToProposal < ActiveRecord::Migration[5.2]
  def change
    add_column :proposals, :feedback, :text
  end
end
