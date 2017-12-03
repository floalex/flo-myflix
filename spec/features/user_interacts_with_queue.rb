require 'rails_helper'

feature "User interacts with queue" do
  scenario "user adds and reorders videos in the queue" do
    movies = Fabricate(:category, name: "Movies")
    monk = Fabricate(:video, title: "Monk", category: movies)
    south_park = Fabricate(:video, title: "South Park", category: movies)
    titanic = Fabricate(:video, title: "Titanic", category: movies)
    
    sign_in # user can be anyone here
    add_video_to_queue(monk)
    expect_video_to_be_in_queue(monk)
  
    visit video_path(monk)
    expect_link_not_to_be_seen("+ My Queue")
    
    add_video_to_queue(south_park)
    add_video_to_queue(titanic)

    set_video_position(monk, 3)
    set_video_position(south_park, 1)
    set_video_position(titanic, 2)
    
    update_queue
    
    expect_video_position(south_park, 1)
    expect_video_position(titanic, 2)
    expect_video_position(monk, 3)
  end
  
  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end
  
  def expect_link_not_to_be_seen(link)
    expect(page).not_to have_content(link)
  end
  
  def update_queue
    click_button "Update Instant Queue"
  end
  
  def add_video_to_queue(video)
    visit home_path
    click_on_video_on_home_page(video)
    click_link "+ My Queue"
  end
  
  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end
  
  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq("#{position}")
  end
end