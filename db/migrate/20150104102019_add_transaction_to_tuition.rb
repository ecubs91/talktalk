class AddTransactionToTuition < ActiveRecord::Migration
  def change
    add_column :tuitions, :payment_transaction, :string
    add_column :tuitions, :payment_amount, :float
  end
end
