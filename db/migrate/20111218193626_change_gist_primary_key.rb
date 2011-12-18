class ChangeGistPrimaryKey < ActiveRecord::Migration
  def up
    change_table :gists do |t|
      t.remove :key
      t.string :key, :primary_key
    end
  end

  def down
    change_table :gists do |t|
      t.remove :key
      t.string :key
    end
  end
end
