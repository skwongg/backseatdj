class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title    ##Soundcloud outputs weren't helpful
      t.integer :track_id
      t.belongs_to :playlist
      t.integer :upskip, default: 0
      t.integer :downskip, default: 0
      t.integer :upreplay, default: 0
      t.integer :downreplay, default: 0

      t.timestamps null: false
    end
  end
end
