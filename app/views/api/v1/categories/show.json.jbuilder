json.(@category, :id, :name) if signed_in?

json.videos @category.videos, :title, :description
