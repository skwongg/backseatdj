class Song < ActiveRecord::Base
	belongs_to :playlist
  validates_uniqueness_of :track_id, :scope => [:playlist_id]
end
