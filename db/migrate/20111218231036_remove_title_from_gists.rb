class RemoveTitleFromGists < ActiveRecord::Migration
  def up
    remove_column :gists, :title
  end

  def down
    add_column :gists, :title
  end
end
