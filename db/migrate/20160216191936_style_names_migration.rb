class StyleNamesMigration < ActiveRecord::Migration
  def change
    Beer.all.each do |r|
      luku = 0
      if Style.count == 0
        Style.create name:r.style
      else
        Style.all.each do |a|
          if a.name == r.style
            luku = 1
          end
        end
        if luku == 0
          Style.create name:r.style
          luku = 0
        end
      end
    end
  end
end
