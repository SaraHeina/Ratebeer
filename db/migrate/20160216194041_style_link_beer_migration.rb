class StyleLinkBeerMigration < ActiveRecord::Migration
  def change
    Beer.all.each do |r|
      Style.all.each do |a|
        if a.name == r.old_style
          r.update_attribute :style_id, (a.id)
        end
      end
    end
  end
end
