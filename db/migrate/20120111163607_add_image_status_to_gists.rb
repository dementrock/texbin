class AddImageStatusToGists < ActiveRecord::Migration
  def change
    add_column :gists, :image_status, :string, :default => 'wait'
  end
end
