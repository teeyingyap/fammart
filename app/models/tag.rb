class Tag < ApplicationRecord
	#many-to-many: Locations can have many tags, Tags have many locations 
	has_many :taggings
	has_many :locations, through: :taggings
end
