---
--- @author zsh in 2023/1/12 18:48
---


local function setNewName(self)
    local name = self.inst.name or STRINGS.NAMES[string.upper(self.inst.prefab)] or "MISSING NAME";
    if self.inst.components.named == nil then
        self.inst:AddComponent("named")
    end
    if not string.find(name, "^进阶·") then
        self.inst.components.named:SetName("进阶·" .. name);
    end
end

---
---拦截 DoDelta，让数值减少的，变为 0 （如果 DoDelta 存在）
---
local function generate_DoDelta(old_fn)
    if old_fn == nil then
        return old_fn
    end
    return function(self, amount, ...)
        if amount < 0 then
            amount = 0
        end
        local res = { old_fn(self, amount, ...) }
        return unpack(res, 1, table.maxn(res))
    end
end

local function onmakeinfinite(self, makeinfinite)
    if makeinfinite then
        local function onsuccess()
            self.inst:RemoveTag("mone_pheromonestone_infinite");
            self.inst:AddTag("hide_percentage")
            setNewName(self)
        end

        local success = false

        if self.inst.components.fueled then
            self.inst.components.fueled.StartConsuming = function(self, ...)
                self:StopConsuming();
            end
            self.inst.components.fueled:StopConsuming();
            self.inst.components.fueled.rate = 0;
            self.inst.components.fueled:SetPercent(1);

            -- 处理一下调用 DoDelta 函数的装备（诸如：旺达的警告表燃料不是 StartConsuming/StopConsuming 而是直接 DoDelta）
            self.inst.components.fueled.DoDelta = generate_DoDelta(self.inst.components.fueled.DoDelta)
            success = true
        end

        if self.inst.components.finiteuses then
            self.inst.components.finiteuses:SetPercent(1)
            local old_Use = self.inst.components.finiteuses.Use
            self.inst.components.finiteuses.Use = function(self, num, ...)
                num = 0;
                if old_Use then
                    return old_Use(self, num, ...);
                end
            end

            self.inst.components.finiteuses.DoDelta = generate_DoDelta(self.inst.components.finiteuses.DoDelta)
            success = true
        end

        if self.inst.components.armor then
            self.inst.components.armor:SetPercent(1);
            self.inst.components.armor.indestructible = true;

            self.inst.components.armor.DoDelta = generate_DoDelta(self.inst.components.armor.DoDelta)
            success = true
        end

        if self.inst.components.perishable then
            self.inst.components.perishable.StartPerishing = function(self, ...)
                self:StopPerishing();
            end
            self.inst.components.perishable:StopPerishing();
            self.inst.components.perishable:SetPercent(1);

            self.inst.components.perishable.DoDelta = generate_DoDelta(self.inst.components.perishable.DoDelta)
            success = true
        end

        -- [2025-11-04] 兼容能力勋章


        if success then
            onsuccess()
        else
            -- 返还，或者提示？
            -- 进阶失败，该物品未兼容，请反馈
        end
    end
end

local Infinite = Class(function(self, inst)
    self.inst = inst;
    self.inst:AddTag("mone_pheromonestone_infinite");
    self.makeinfinite = nil;
end, nil, {
    makeinfinite = onmakeinfinite; -- 只要 self.makeinfinite 被更新一次，这个函数就会被调用，传入的参数有 self、键值
});

local function consumeMaterial(inst)
    if inst.components.stackable then
        inst.components.stackable:Get():Remove()
    else
        inst:Remove()
    end
end

function Infinite:MakeInfinite(invo)
    self.makeinfinite = true;
    TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/collect_resource");
    consumeMaterial(invo)
end

function Infinite:OnSave()
    --print("Infinite:OnSave():"..tostring(self.makeinfinite));
    return {
        makeinfinite = self.makeinfinite;
    }
end

function Infinite:OnLoad(data)
    --print("---Infinite:OnLoad(data)");
    if data and data.makeinfinite then
        --print("Infinite:OnLoad(data)---");
        self.makeinfinite = data.makeinfinite;
    end
end

return Infinite;