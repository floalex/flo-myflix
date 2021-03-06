require 'rails_helper'

describe QueueItemsController do
 
  describe "GET index" do
    it "sets @queue_items for the signed in user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      # set the @queue_items to the array
      expect(assigns[:queue_items]).to match_array([queue_item1, queue_item2])
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end
  
  describe "POST create" do
    it "redirects to the my_queue page" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end
    
    it "creates the queue item" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end
    
    it "creates the queue item associated with the video" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end
    
    it "creates the queue item associated with the singed in user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(alice)
    end
    
    it "puts the new added video as the last one in the queue" do
      alice = Fabricate(:user)
      set_current_user(alice)
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: alice)
      south_park = Fabricate(:video)
      post :create, video_id: south_park.id
      south_park_queue_item = QueueItem.where(video_id: south_park.id, user_id: alice.id).first
      expect(south_park_queue_item.position).to eq(2)
    end
    
    it "doesn't add the duplicate video to the one already existed in the queue" do
      alice = Fabricate(:user)
      set_current_user(alice)
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: alice)
      post :create, video_id: monk.id
      expect(QueueItem.count).to eq(1)
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { post :create, video_id: 3 }
    end
  end
  
  describe "DELETE destroy" do
    it "redirects to the my queue page" do
      set_current_user #without it, the reponse will be redirected to the sign in path
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end
    
    it "deletes the queue in the queue list" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item = Fabricate(:queue_item, user: alice)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end
    
    it "normalizes the remaining queue items" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
      queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
      delete :destroy, id: queue_item1.id
      # alice.queue_items forces to "refresh" the database so we can get the updated queue_items
      expect(alice.queue_items.map(&:position)).to eq([1])
    end
    
    it "does not delete the queue item if that queue item is not in the current user's queue list" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(alice)
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 3 }
    end
  end
  
  describe "POST update_queue" do
    
    it_behaves_like "requires sign in" do
      let(:action) do
        post :update_queue, queue_items: [{id: 2, position: 3}, {id: 5, position: 2}]
      end
    end
    
    context "with valid inputs" do
      
      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2, video: video) }
      
      before do
        set_current_user(alice)
      end
      
      it "redirects to the my queue page" do        
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      
      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end
      
      it "normalizes the positions numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        # alice.queue_items forces to "refresh" the database so we can get the updated queue_items
        expect(alice.queue_items.map(&:position)).to eq([1, 2])
        # alternative:
        # expect(queue_item1.reload.position).to eq(2)
        # expect(queue_item2.reload.position).to eq(1)
      end
    end
    
    context "with invalid inputs" do
      
      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2, video: video) }
      
      before do
        set_current_user(alice)
      end
      
      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      
      it "sets the error flash message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.2}, {id: queue_item2.id, position: 1}]
        expect(flash[:danger]).to be_present
      end
      
      it "does not change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
      
    end
    
    context "with queue items that don't belong to the current user" do
      it "does not change the queue items" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        set_current_user(alice)
        queue_item1 = Fabricate(:queue_item, user: bob, position: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end