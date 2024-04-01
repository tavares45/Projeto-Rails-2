class AddUuidToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :uuid, :string
  end
end
