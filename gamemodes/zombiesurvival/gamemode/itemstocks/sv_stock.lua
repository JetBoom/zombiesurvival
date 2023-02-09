include("sh_stock.lua")

AddCSLuaFile("cl_stock.lua")
AddCSLuaFile("sh_stock.lua")

function GM:SetItemStocks(itemid, stock)
	self.ItemStocks[itemid] = stock

	self:SendItemStocks(itemid)
end

function GM:AddItemStocks(itemid, stock)
	local currentstock = self:GetItemStocks(itemid)
	if currentstock ~= -1 then
		self:SetItemStocks(itemid, math.max(currentstock + stock, 0))
	end
end

function GM:RefreshItemStocks(pl)
	for k in pairs(self.ItemStocks) do
		self:SendItemStocks(pl)
	end
end

function GM:SendItemStocks(itemid, pl)
	net.Start("zs_itemstock")
		net.WriteString(tostring(itemid))
		net.WriteInt(self:GetItemStocks(itemid), 16)
	if pl then
		net.Send(pl)
	else
		net.Send(team.GetPlayers(TEAM_HUMAN))
	end
end

function GM:ClearItemStocks(nosend)
	self.ItemStocks = {}

	if not nosend then
		self:RefreshItemStocks()
	end
end
