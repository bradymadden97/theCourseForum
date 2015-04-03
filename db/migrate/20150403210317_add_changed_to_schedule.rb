class AddChangedToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :changed, :boolean
  end
end
