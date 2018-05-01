GM.ItemStocks = {}

function GM:GetItemStocks(itemid)
	if self.ItemStocks[itemid] then
		return self.ItemStocks[itemid]
	end

	local item = FindItem(itemid)
	if item and item.MaxStock then
		return item.MaxStock
	end

	return -1
end

function GM:HasItemStocks(itemid)
	local stock = self:GetItemStocks(itemid)
	return stock > 0 or stock == -1
end
