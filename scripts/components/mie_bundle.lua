---
--- @author zsh in 2023/2/10 12:39
---

local function onname(self, name, old)
    self.inst._name:set(tostring(name));
end

local Bundle = Class(function(self, inst)
    self.inst = inst;

    self.name = nil;

    self.canpackfn = nil;
    self.prefabs = nil;

    self.ordinary_packaging = false;
end, nil, {
    name = onname
});

local function cannot(target)
    for _, v in ipairs({
        "teleportato",
        "player", "companion", "character", "abigail",
        "irreplaceable", "bundle", "nobundling"
    }) do
        if target:HasTag(v) then
            return true;
        end
    end
    for _, v in ipairs({
        "beequeenhive", "multiplayer_portal",
        "cave_entrance", "cave_entrance_ruins", "cave_entrance_open", "cave_exit",
        "winch" -- 25/06/04: 夹夹绞盘可以卡 bug，杜绝该情况
    }) do
        if target.prefab == v then
            return true;
        end
    end
end

local function can(target)
    if not (target and target:IsValid() and not target:IsInLimbo()) then
        return ;
    end
    for _, v in ipairs({

    }) do
        if target:HasTag(v) then
            return true;
        end
    end
    if target:HasTag("heavy") and string.find(target.prefab, "chesspiece_") then
        return true;
    end
    if string.find(target.prefab, "^medal_statue")
            or string.find(target.prefab, "^plant_plantmeat")
            or string.find(target.prefab, "^plant_(.-)_(l)$")
    --or string.find(target.prefab, "^plant_(.-)_(%d+)$")
    then
        return true;
    end
    for _, v in ipairs({
        "pigking", "moonbase", "statueglommer", "critterlab", -- 猪王、月台、格罗姆、岩石巢穴
        "grotto_pool_small", "grotto_pool_big", -- 玻璃绿洲
        "eyeturret", -- 眼睛炮塔
        "wormhole", -- 虫洞
        "minotaurchest", -- 大号华丽箱子
        "stagehand", -- 舞台之手
        "pond", "pond_cave", "pond_mos", -- 三种池塘
        "sanityrock", -- 方尖碑
        "insanityrock",
        "mone_dummytarget", -- 皮痒傀儡
        "mone_arborist", -- 树木栽培家
        "beebox_hermit", "meatrack_hermit",
        "beequeenhive", -- 蜂蜜地块
        "mound", -- 坟墓
        "gravestone", -- 墓碑
        "skeleton",
        "siving_soil",
        "monkeyisland_portal", -- 非自然传送门
        "waterplant",
        "walrus_camp", -- 海象巢穴
        "townportal", -- 懒人传送塔

        "mone_single_dog", -- 我 mod 的单身狗
    }) do
        if target.prefab == v then
            return true;
        end
    end
end

local function IsLegitimateTargetAboutOrdinaryPackaging(target)
    -- 允许打包所有能被摧毁的类建筑目标
    if target:HasTag("mie_ordinary_bundle_legitimate_target") then
        return true
    end
    for _, v in ipairs({
        "mone_dummytarget", -- 皮痒傀儡
        "critterlab", -- 岩石巢穴
        "wasphive", -- 杀人蜂巢穴
    }) do
        if target.prefab == v then
            return true
        end
    end
    return false
end

local BUNDLE_ANYTHING = true

local function IsLegitimateTargetAboutBundleAnything(target)
    return target
        and target:IsValid()
        and not target:IsInLimbo()
        and not target.prefab:find("hermithouse")
        and not (
            target:HasTag("teleportato")
            or target:HasTag("player")
            or target:HasTag("nonpackable")
            or target:HasTag("companion")
            or target:HasTag("character")
            or target.prefab =="beequeenhive"
            or target.prefab =="cave_entrance"
            or target.prefab =="cave_entrance_ruins"
            or target.prefab =="cave_entrance_open"
            or target.prefab == "multiplayer_portal"
            or target.prefab == "plant_normal"
        )
end

---
---检测是否是合法目标
---
function Bundle:IsLegitimateTarget(target)
    if not (target and target:IsValid() and not target:IsInLimbo()) then
        return ;
    end

    -- 禁止夹夹绞盘
    if target.prefab == "winch" then
        return false
    end

    if self.ordinary_packaging then
        return IsLegitimateTargetAboutOrdinaryPackaging(target)
    end

    if BUNDLE_ANYTHING then
        return IsLegitimateTargetAboutBundleAnything(target)
    end


    -- 打个补丁
    if target.prefab == "eyeturret" -- 眼球塔
            or target.prefab == "sculpture_bishophead" -- 可疑的大理石
            or target.prefab == "sculpture_knighthead" -- 可疑的大理石
            or target.prefab == "sculpture_rooknose" -- 可疑的大理石
            or target.prefab == "plant_nepenthes_l"
    --or string.find(target.prefab, "^sculpture_")
    then
        return true;
    end

    if target:HasTag("mie_bundle_can_target") then
        return true;
    end

    if cannot(target) then
        return ;
    end
    if target:HasTag("structure") then
        return true;
    end
    if can(target) then
        return true;
    end

    -- 如果设置了不限制打包对象，则除了 cannot 限制的目标，几乎都能打包
    if TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA.bundle_anything then
        return true
    end

    return ;
end

local function displayTargetName(target)
    local displayname = target:GetDisplayName() or (target.components.named and target.components.named.name);

    if displayname == nil or displayname == "MISSING NAME" then
        return "REAL MISSING NAME";
    end

    local adjective = target:GetAdjective();
    if adjective then
        displayname = adjective .. " " .. displayname;
    end
    if target.components.stackable then
        local stacksize = target.components.stackable:StackSize()
        if stacksize > 1 then
            displayname = displayname .. " x" .. tostring(stacksize)
        end
    end
    return displayname;
end

function Bundle:Main(target, invobject, doer)
    if not (target and target:IsValid() and not target:IsInLimbo()) then
        return ;
    end
    self.prefabs = {
        prefab1 = target:GetSaveRecord();
    }
    if target.components.teleporter and target.components.teleporter.targetTeleporter then
        self.prefabs.prefab2 = target.components.teleporter.targetTeleporter:GetSaveRecord();
        target.components.teleporter.targetTeleporter:Remove();
    end
    self.name = displayTargetName(target);
    target:Remove();

    invobject:Remove();
    if doer.SoundEmitter then
        doer.SoundEmitter:PlaySound("dontstarve/common/staff_dissassemble");
    end

    return true;
end

function Bundle:Deploy(pt)
    local x, y, z = pt:Get();
    if x and y and z then
        inGamePlay = false;

        if self.prefabs and type(self.prefabs) == "table" then
            local prefab1, prefab2 = self.prefabs.prefab1, self.prefabs.prefab2;

            local one;
            if prefab1 then
                local prefab = SpawnSaveRecord(prefab1);
                one = prefab;
                if prefab and prefab:IsValid() then
                    if prefab.Physics then
                        prefab.Physics:Teleport(pt:Get());
                    else
                        prefab.Transform:SetPosition(pt:Get())
                    end

                    if prefab.components.inventoryitem then
                        prefab.components.inventoryitem:OnDropped(true, .5);
                    end
                end
            end

            -- 虫洞之类的
            if prefab2 then
                local two = SpawnSaveRecord(prefab2);
                if one and one:IsValid() and two and two:IsValid() then
                    if one.components.teleporter and two.components.teleporter then
                        one.components.teleporter:Target(two);
                        two.components.teleporter:Target(one);
                    end
                end
            end
        end

        inGamePlay = true;
    end
end

function Bundle:OnSave()
    return {
        prefabs = self.prefabs;
        name = self.name;
        ordinary_packaging = self.ordinary_packaging;
    };
end

function Bundle:OnLoad(data)
    if data then
        if data.prefabs then
            self.prefabs = data.prefabs;
        end
        if data.name then
            self.name = data.name;
        end
        if data.ordinary_packaging then
            self.ordinary_packaging = data.ordinary_packaging
        end
    end
end

return Bundle;