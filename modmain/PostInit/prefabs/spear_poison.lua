---
--- DateTime: 2025/11/5 18:09
---

-- 现在毒矛将拥有真实伤害，首先是修改 DoDelta 函数，如果是被毒矛攻击，则无视防御

env.AddComponentPostInit("health", function(self, inst)
    local old_DoDelta = self.DoDelta

    function self:DoDelta(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
        -- 如果来自毒矛，则造成真实伤害
        if self.inst.rmi_from_spear_poison then
            ignore_invincible = true
            ignore_absorb = true
        end
        return old_DoDelta(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
    end
end)