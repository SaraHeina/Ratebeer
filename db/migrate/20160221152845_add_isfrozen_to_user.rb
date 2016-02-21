class AddIsfrozenToUser < ActiveRecord::Migration
  def change
    add_column :users, :isfrozen, :boolean
  end
end
