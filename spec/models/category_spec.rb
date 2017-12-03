require 'rails_helper'

describe Category do
  it {should have_many(:videos) }
  it { should validate_presence_of(:name) }
  
  describe "#recent_videos" do
    it "returns the videos in the reverse chronical order by created_at" do
      movies = Category.create(name: "Movies")
      alien = Video.create(title: "Alien", description: "Classic sci-fi", category: movies, created_at: 1.day.ago)
      lala_land = Video.create(title: "La La Land", description: "Great music!", category: movies)
      expect(movies.recent_videos).to eq([lala_land, alien])
    end
    
    it "returns all the videos if there are less than 6 videos" do
      movies = Category.create(name: "Movies")
      alien = Video.create(title: "Alien", description: "Classic sci-fi", category: movies, created_at: 1.day.ago)
      lala_land = Video.create(title: "La La Land", description: "Great music!", category: movies)
      expect(movies.recent_videos.count).to eq(2)
    end
    
    it "returns 6 videos if there are more than 6 videos" do
      movies = Category.create(name: "Movies")
      7.times { Video.create(title: "La La Land", description: "Great music!", category: movies) }
      expect(movies.recent_videos.count).to eq(6)
    end
    
    it "returns the most recent 6 videos" do
      movies = Category.create(name: "Movies")
      alien = Video.create(title: "Alien", description: "Classic sci-fi", category: movies, created_at: 1.day.ago)
      6.times { Video.create(title: "La La Land", description: "Great music!", category: movies) }
      expect(movies.recent_videos).not_to include(alien)
    end
    
    it "returns an empty array if no video in that category" do
      movies = Category.create(name: "Movies")
      expect(movies.recent_videos).to eq([])
    end
  end
end