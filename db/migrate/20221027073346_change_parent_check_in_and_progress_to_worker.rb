class ChangeParentCheckInAndProgressToWorker < ActiveRecord::Migration[7.0]
  def change
    remove_column :check_ins, :job_id
    add_column :check_ins, :worker_id, :integer
    remove_column :progresses, :check_in_id
    add_column :progresses, :worker_id, :integer
  end
end
