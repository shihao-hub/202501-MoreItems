
-- ICE FLOE
local function ice_floe_deploy_blocker_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    -- Prevent things from being deployed onto the ice floes. 
    inst:SetDeployExtraSpacing(TUNING.OCEAN_ICE_RADIUS + 0.1)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function ice_ondeath(inst)
	if inst:IsAsleep() then
		if not inst.sg:HasStateTag("dead") then
			for ent in pairs(inst.components.walkableplatform:GetEntitiesOnPlatform()) do
				ent:PushEvent("abandon_ship")
			end
		end
		inst.sinkloot_asleep()
		inst:Remove()
	end
end

local function ice_fn()
    local inst = CreateEntity()

    local bank = "boat_ice"
    local build = "boat_ice"
    local OCEANICE_BOAT_DATA = {
        radius = TUNING.OCEAN_ICE_RADIUS,
        max_health = TUNING.OCEAN_ICE_HEALTH,
        item_collision_prefab = "boat_ice_item_collision",
        boatlip_prefab = "boatlip_ice",
        stategraph = "SGboat_ice",
        fireproof = true,
    }

    inst = create_common_pre(inst, bank, build, OCEANICE_BOAT_DATA)

    inst:RemoveTag("wood") -- Cookie Cutters should not eat it.

    inst.material = "ice"
    inst.walksound = "ice"

    inst.components.walkableplatform.player_collision_prefab = "boat_ice_player_collision"

    local boattrail = inst.components.boattrail
    if boattrail then
        local scale = TUNING.OCEAN_ICE_RADIUS / TUNING.BOAT.RADIUS
        boattrail.scale_x = scale
        boattrail.scale_y = scale

        boattrail.radius = boattrail.radius * scale
    end

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.GetIdleLevel = function()
        local health_percent = inst.components.health:GetPercent()
        return (health_percent > 0.66 and "1")
            or (health_percent > 0.33 and "2")
            or "3"
    end

    inst = create_master_pst(inst, OCEANICE_BOAT_DATA)

	inst:ListenForEvent("spawnnewboatleak", OnSpawnNewBoatLeak)
	inst:ListenForEvent("death", ice_ondeath)

    inst.components.hullhealth:SetSelfDegrading(1)
    inst.components.hullhealth.leakproof = true

    inst.components.repairable.repairmaterial = nil

    inst.sounds = sounds_ice
    inst.boat_crackle = "mining_ice_fx"

    inst:DoTaskInTime(FRAMES, function(i)
        local ix, iy, iz = i.Transform:GetWorldPosition()
        local deploy_blocker = SpawnPrefab("boat_ice_deploy_blocker")
        deploy_blocker.Transform:SetPosition(ix, iy, iz)
    end)

    inst.sinkloot = function()
        local ignitefragments = false --(inst.activefires > 0)
        local locus_point = inst:GetPosition()
        local num_loot = 3
        local loot_angle = PI2/num_loot
        local loot_radius = (OCEANICE_BOAT_DATA.radius/2)
        for i = 1, num_loot do
            local r = (1 + math.sqrt(math.random()))*loot_radius
            local t = (i + 2 * math.random()) * loot_angle
            SpawnFragment(locus_point, "ice", math.cos(t) * r, 0, math.sin(t) * r, ignitefragments)

            r = (1 + math.sqrt(math.random()))*loot_radius
            t = t + loot_angle * (0.3 + 0.6 * math.random())
            SpawnFragment(locus_point, "degrade_fx_ice", math.cos(t) * r, 0, math.sin(t) * r)
        end
    end
	inst.sinkloot_asleep = function()
		local num_loot = math.random(3) - 1
		if num_loot > 0 then
			local locus_point = inst:GetPosition()
			local loot_angle = PI2/num_loot
			local loot_radius = (OCEANICE_BOAT_DATA.radius/2)
			for i = 1, num_loot do
				local r = (1 + math.sqrt(math.random()))*loot_radius
				local t = (i + 2 * math.random()) * loot_angle
				SpawnFragment(locus_point, "ice", math.cos(t) * r, 0, math.sin(t) * r, false)
			end
		end
	end
    inst.postsinkfn = function(inst)
        local break_fx = SpawnPrefab("mining_ice_fx")
        break_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end

    inst.SpawnFragment = SpawnFragment

    return inst
end



return Prefab("boat_ice", ice_fn, ice_assets, ice_prefabs),
MakePlacer("boat_ice_placer", "boat_01", "boat_test", "idle_full", true, false, false, nil, nil, nil, ControllerPlacer_Boat_SpotFinder, 6)

