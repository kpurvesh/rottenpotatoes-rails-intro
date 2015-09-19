class Movie < ActiveRecord::Base

    def self.get_all_ratings
	all_ratings = uniq.pluck(:rating);
	return all_ratings;
    end
end
