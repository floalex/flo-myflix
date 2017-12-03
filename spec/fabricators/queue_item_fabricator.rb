Fabricator(:queue_item) do
  # give random number
  position { [1, 2, 3].sample}
end