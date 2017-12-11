module ApplicationHelper
  def options_for_video_reviews(selected=nil)
    options_for_select((1..5).map {|num| [pluralize(num, "Star"), num]}, selected) # ['1 Star', 1] <option value="1">1 Star</option>
  end
  
  def options_for_video_categories
    options_for_select(Category.all.map do
      |category| [category.name, category.id]
    end)
  end
end
