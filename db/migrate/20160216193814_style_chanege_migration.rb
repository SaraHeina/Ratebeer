class StyleChanegeMigration < ActiveRecord::Migration
  def change
    rename_column :beers, :style, :old_style
    add_column :beers, :style_id, :integer
  end
end
