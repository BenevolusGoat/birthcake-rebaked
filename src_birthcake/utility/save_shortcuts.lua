local save_manager = BirthcakeRebaked.SaveManager

---@param ent? Entity @If an entity is provided, returns an entity specific save within the run save. Otherwise, returns arbitrary data in the save not attached to an entity.
---@param noHourglass false|boolean? @If true, it'll look in a separate game save that is not affected by the Glowing Hourglass.
---@return table @Can return nil if data has not been loaded, or the manager has not been initialized. Will create data if none exists.
function BirthcakeRebaked:RunSave(ent, noHourglass)
	return save_manager.GetRunSave(ent, noHourglass)
end

---@param pickup? EntityPickup @If an entity is provided, returns an entity specific save within the roomFloor save, which is a floor-lasting save that has unique data per-room. If a Vector is provided, returns a grid index specific save. Otherwise, returns arbitrary data in the save not attached to an entity.
---@param noHourglass false|boolean? @If true, it'll look in a separate game save that is not affected by the Glowing Hourglass.
---@param listIndex? integer @Returns data for the provided `listIndex` instead of the index of the current room.
---@return table? @Can return nil if data has not been loaded, or the manager has not been initialized, or if no data already existed.
function BirthcakeRebaked:TryGetRerollSave(pickup, noHourglass, listIndex)
	local pickup_save = save_manager.TryGetRoomSave(pickup, noHourglass, listIndex)
	if pickup_save then
		return pickup_save.RerollSave
	end
end

---@param pickup? EntityPickup @If an entity is provided, returns an entity specific save within the roomFloor save, which is a floor-lasting save that has unique data per-room. If a Vector is provided, returns a grid index specific save. Otherwise, returns arbitrary data in the save not attached to an entity.
---@param noHourglass false|boolean? @If true, it'll look in a separate game save that is not affected by the Glowing Hourglass.
---@param listIndex? integer @Returns data for the provided `listIndex` instead of the index of the current room.
---@return table @Can return nil if data has not been loaded, or the manager has not been initialized. Will create data if none exists.
function BirthcakeRebaked:GetRerollSave(pickup, noHourglass, listIndex)
	return save_manager.TryGetRoomSave(pickup, noHourglass, listIndex).RerollSave
end

---@param pickup? EntityPickup @If an entity is provided, returns an entity specific save within the roomFloor save, which is a floor-lasting save that has unique data per-room. If a Vector is provided, returns a grid index specific save. Otherwise, returns arbitrary data in the save not attached to an entity.
---@param noHourglass false|boolean? @If true, it'll look in a separate game save that is not affected by the Glowing Hourglass.
---@param listIndex? integer @Returns data for the provided `listIndex` instead of the index of the current room.
---@return table? @Can return nil if data has not been loaded, or the manager has not been initialized, or if no data already existed.
function BirthcakeRebaked:TryGetNoRerollSave(pickup, noHourglass, listIndex)
	local pickup_save = save_manager.TryGetRoomSave(pickup, noHourglass, listIndex)
	if pickup_save then
		return pickup_save.NoRerollSave
	end
end

---@param pickup? EntityPickup @If an entity is provided, returns an entity specific save within the roomFloor save, which is a floor-lasting save that has unique data per-room. If a Vector is provided, returns a grid index specific save. Otherwise, returns arbitrary data in the save not attached to an entity.
---@param noHourglass false|boolean? @If true, it'll look in a separate game save that is not affected by the Glowing Hourglass.
---@param listIndex? integer @Returns data for the provided `listIndex` instead of the index of the current room.
---@return table @Can return nil if data has not been loaded, or the manager has not been initialized. Will create data if none exists.
function BirthcakeRebaked:GetNoRerollSave(pickup, noHourglass, listIndex)
	return save_manager.TryGetRoomSave(pickup, noHourglass, listIndex).NoRerollSave
end

---@param ent? Entity  @If an entity is provided, returns an entity specific save within the floor save. Otherwise, returns arbitrary data in the save not attached to an entity.
---@param noHourglass false|boolean? @If true, it'll look in a separate game save that is not affected by the Glowing Hourglass.
---@return table @Can return nil if data has not been loaded, or the manager has not been initialized. Will create data if none exists.
function BirthcakeRebaked:GetFloorSave(ent, noHourglass)
	return save_manager.GetFloorSave(ent, noHourglass)
end