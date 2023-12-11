class CreateCurrencyRates < ActiveRecord::Migration[7.1]
  def change
    create_table :currency_rates do |t|
      t.integer :kind, null: false
      t.date :date, null: false
      t.decimal :value, null: false

      t.timestamps
    end
    add_index :currency_rates, :kind
    add_index :currency_rates, [:kind, :date], unique: true
  end
end
