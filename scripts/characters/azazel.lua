local mod = Birthcake
local game = Game()
local AzazelCake = {}
local charge = 0
local charge2 = 0
local frameCounter = 0
local frequency = 10

-- functions

function AzazelCake:CheckAzazel(player)
    return player:GetPlayerType() == PlayerType.PLAYER_AZAZEL
end

function AzazelCake:CheckAzazelB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_AZAZEL_B
end

-- Azazel Birthcake

function AzazelCake:ShootTears()
    local player = Isaac.GetPlayer(0)

    if not AzazelCake:CheckAzazel(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    if tostring(player:GetShootingInput()) ~= "0 0" or player:AreOpposingShootDirectionsPressed() then
        charge = charge + 1
        if charge >= player.MaxFireDelay then
            frameCounter = frameCounter + 1
            if frameCounter % math.floor(player.MaxFireDelay/2) == 0 then
                player:FireTear(player.Position, player:GetAimDirection()*10, false, false, false,player,0.5)
            end
        end
    else
        charge = 0
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, AzazelCake.ShootTears)

-- Tainted Azazel Birthcake

function AzazelCake:GetInvertedDirection(vector)
    return Vector(-vector.X, -vector.Y)
end

function AzazelCake:Sneeze()
    local player = Isaac.GetPlayer(0)

    if not AzazelCake:CheckAzazelB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    if tostring(player:GetShootingInput()) ~= "0 0" or player:AreOpposingShootDirectionsPressed() or player.FireDelay > 0 then
        if charge == 0 then
            if tostring(player:GetMovementInput()) ~= "0 0" then
                if tostring(player:GetMovementInput()) == tostring(player:GetShootingInput()) then
                    player:AddVelocity(AzazelCake:GetInvertedDirection(player:GetShootingInput())*15)
                else
                    player:AddVelocity(AzazelCake:GetInvertedDirection(player:GetShootingInput())*10)
                end
            else
                player:AddVelocity(AzazelCake:GetInvertedDirection(player:GetShootingInput())*8)
            end
            charge = charge + 1
        end
    else
        charge = 0
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, AzazelCake.Sneeze)

function AzazelCake:AzazelSickness(entity, dmg, dmgFlag, dmgSource, dmgCountdownFrames)
    local player = Isaac.GetPlayer(0)

    if not AzazelCake:CheckAzazelB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    Isaac.ConsoleOutput(tostring(dmgFlag))

    if entity:IsEnemy() and dmgSource.Type == EntityType.ENTITY_PLAYER and dmgFlag == 0 then
        if player.FireDelay == -1 then
            entity:AddPoison(EntityRef(player), 23*10, player.Damage)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, AzazelCake.AzazelSickness)