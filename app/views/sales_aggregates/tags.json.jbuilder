json.array! @tags.each do |tag|
	json.tag tag["_id"]
	json.qty tag["value"]["qty"]
	json.value tag["value"]["value"]
end