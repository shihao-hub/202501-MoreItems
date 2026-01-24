---
--- @author zsh in 2023/1/9 18:09
---


local API = require("chang_mone.dsts.API");

local config_data = TUNING.MONE_TUNING.GET_MOD_CONFIG_DATA;


-- 不行，会出错
--API.reskin("lureplant", "eyeplant_trap", {
--    "rmi_lureplant"
--});

--API.reskin2(env, "lureplant", "eyeplant_trap", "eyeplant_trap", {
--    "rmi_lureplant"
--});

API.reskin("hambat", "ham_bat", {
    "mone_hambat"
});

API.reskin("meatrack", "meat_rack", {
    "mone_meatrack"
});

API.reskin("orangestaff", "staffs", {
    "mone_orangestaff"
});

API.reskin("boomerang", "boomerang", {
    "mone_boomerang"
});

API.reskin("backpack", "swap_backpack", {
    "mone_backpack"
}, { env = env });

API.reskin("piggyback", "swap_piggyback", {
    "mone_piggyback"
});

API.reskin("icepack", "swap_icepack", {
    "mone_icepack"
});

API.reskin("spicepack", "swap_chefpack", {
    "mone_spicepack"
});

API.reskin("firesuppressor", "firefighter", {
    "mone_firesuppressor"
});

API.reskin("treasurechest", "treasure_chest", {
    "mone_treasurechest"
});
API.reskin("dragonflychest", "dragonfly_chest", {
    "mone_dragonflychest"
});
API.reskin("icebox", "ice_box", {
    "mone_icebox"
});
API.reskin("saltbox", "saltbox", {
    "mone_saltbox"
});
API.reskin("wardrobe", "wardrobe", {
    "mone_wardrobe"
});
API.reskin("dragonflyfurnace", "dragonfly_furnace", {
    "mone_dragonflyfurnace"
});
API.reskin("moondial", "moondial_build", {
    "mone_moondial"
});

API.reskin("seedpouch", "seedpouch", {
    "mone_seedpouch"
});

if config_data.mone_seasack_new_anim then
    API.reskin("krampus_sack", "swap_krampus_sack", {
        "mone_seasack"
    });
end

if config_data.piggybag__change_image_enable then
    API.reskin("piggyback", "swap_piggyback", {
        "mone_piggybag"
    })
end

-- region 更多物品·拓展包
if config_data.mie_bushhat then
    API.reskin2(env, "bushhat", "bushhat", "hat_bush", {
        "mie_bushhat"
    });
end

if config_data.mie_tophat then
    API.reskin2(env, "tophat", "tophat", "hat_top", {
        "mie_tophat"
    });
end


API.reskin("waterpump", "boat_waterpump", {
    "mie_waterpump"
});

if config_data.mie_fish_box_animstate then
    API.reskin("saltbox", "saltbox", {
        "mie_fish_box"
    });
else
    API.reskin("fish_box", "fish_box", {
        "mie_fish_box"
    });
end

API.reskin("resurrectionstatue", "wilsonstatue", {
    "mone_dummytarget"
});
-- endregion
