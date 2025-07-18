class AddWeightingToYears < ActiveRecord::Migration[7.1]
  def change
    add_column :years, :weighting, :float
  end
end
