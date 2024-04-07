include("sh_stock.lua")

function GM:ClearItemStocks()
	self.ItemStocks = {}
end

net.Receive("zs_itemstock", function(length)
	local itemid = net.ReadString()
	local stock = net.ReadInt(16)

	GAMEMODE.ItemStocks[itemid] = stock
end)
