require 'rails_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order(created_at: :desc) }
  
  describe "search_by_title" do
    it "returns an empty array if no video matched" do
      alien = Video.create(title: "Alien", description: "Classic sci-fi")
      lala_land = Video.create(title: "La La Land", description: "Great music!")
      expect(Video.search_by_title("hello")).to eq([])
    end
    
    it "returns an array of one video for an exact match" do
      alien = Video.create(title: "Alien", description: "Classic sci-fi")
      lala_land = Video.create(title: "La La Land", description: "Great music!")
      expect(Video.search_by_title("Alien")).to eq([alien])
    end
    
    it "returns an array of one video for a partial match" do 
      alien = Video.create(title: "Alien", description: "Classic sci-fi")
      lala_land = Video.create(title: "La La Land", description: "Great music!")
      expect(Video.search_by_title("lie")).to eq([alien])
    end
    
    it "returns an array of one video for case sensitive partial match" do 
      alien = Video.create(title: "Alien", description: "Classic sci-fi")
      lala_land = Video.create(title: "La La Land", description: "Great music!")
      expect(Video.search_by_title("ali")).to eq([alien])
    end
    
    it "returns an array of all matches ordered by created_at" do
      alien = Video.create(title: "Alien", description: "Classic sci-fi", created_at: 1.day.ago)
      lala_land = Video.create(title: "La La Land", description: "Great music!")
      expect(Video.search_by_title("a")).to eq([lala_land, alien])
    end
    
    it "returns an empty array if the search term is empty or whitespace" do
      alien = Video.create(title: "Alien", description: "Classic sci-fi")
      lala_land = Video.create(title: "La La Land", description: "Great music!")
      expect(Video.search_by_title(" ")).to eq([])
      expect(Video.search_by_title("")).to eq([])
    end
  end
end
