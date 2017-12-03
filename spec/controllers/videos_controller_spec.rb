require 'rails_helper'

describe VideosController do
  let (:video) { Fabricate(:video) }
  
  describe 'GET show' do
    it "sets @video for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
    
    it "sets @reviews for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      # =~: regardless of the orders
      expect(assigns(:reviews)).to match_array([review1, review2])
    end
    
    it "redirects to sign in page for unauthenticated users" do
      get :show, id: video.id
      expect(response).to redirect_to(sign_in_path)
    end
    
  end
  
  describe 'GET search' do
    let (:video) { Fabricate(:video, title: 'Futurama') }
    
    it "sets @results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :search, search_term: 'rama'
      expect(assigns(:results)).to eq([video])
    end
    
    it "redirects to sign in page for unauthenticated users" do
      get :search
      expect(response).to redirect_to(sign_in_path)
    end
  end
end