class AddRegisteredRefToProposal < ActiveRecord::Migration[5.2]
  def change
    add_reference :proposals, :registered, foreign_key: true
  end
end
