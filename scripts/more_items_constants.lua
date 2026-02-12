local module = {
    LIFE_INJECTOR_VB__INCLUDED_PLAYERS = {
        -- 排除 旺达、机器人、小鱼人
        "wilson", "willow", "wolfgang", "wendy", "wickerbottom", "woodie", "wes", "waxwell",
        "wathgrithr", "webber", "winona", "warly", "wortox", "wormwood", "wonkey", "walter",
        -- 加回 机器人
        "wx78", --[["wurt","wanda",]] -- 旺达和小鱼人有点不好处理
        "jinx", -- https://steamcommunity.com/sharedfiles/filedetails/?id=479243762
        "monkey_king", "neza", "white_bone", "pigsy", "yangjian", "myth_yutu", "yama_commissioners", "madameweb",
    },
    LIFE_INJECTOR_VB__PER_ADD_NUM = 10,

    STOMACH_WARMING_HAMBURGER__PER_ADD_NUM = 10,
    STOMACH_WARMING_HAMBURGER__INCLUDED_PLAYERS = {
        -- 参考强心素食堡，包含原版人物
        "wilson", "willow", "wolfgang", "wendy", "wickerbottom", "woodie", "wes", "waxwell",
        "wathgrithr", "webber", "winona", "warly", "wortox", "wormwood", "wonkey", "walter",
        "wx78", "wurt", "wanda",
        "jinx",
        "monkey_king", "neza", "white_bone", "pigsy", "yangjian", "myth_yutu", "yama_commissioners", "madameweb",
    },

    SANITY_HAMBURGER__PER_ADD_NUM = 10,
    SANITY_HAMBURGER__INCLUDED_PLAYERS = {
        -- 参考暖胃汉堡包，包含原版人物
        "wilson", "willow", "wolfgang", "wendy", "wickerbottom", "woodie", "wes", "waxwell",
        "wathgrithr", "webber", "winona", "warly", "wortox", "wormwood", "wonkey", "walter",
        "wx78", "wurt", "wanda",
        "jinx",
        "monkey_king", "neza", "white_bone", "pigsy", "yangjian", "myth_yutu", "yama_commissioners", "madameweb",
    },

    SINGLE_DOG__DETECTION__CYCLE_LENGTH = 2, -- 检测周期
    SINGLE_DOG__DETECTION__RADIUS = 4 * 2.5, -- 一块地皮 4
    SINGLE_DOG__DETECTION__PLACER_SCALE = 1.25, -- 4 * 2.5 / (1888 / 150 / 2), -- OnEnableHelper
    SINGLE_DOG__DETECTION__MUST_TAGS = nil,
    SINGLE_DOG__DETECTION__CANT_TAGS = nil,
    SINGLE_DOG__DETECTION__MUST_ONE_OF_TAGS = { "hound", "buzzard" },
    SINGLE_DOG__DETECTION__BLEEDING_PERCENTAGE = 0.2,
    SINGLE_DOG__OBSTACLE_PHYSICS_HEIGHT = 0.3,
    SINGLE_DOG__WORK_LEFT = 3,
    SINGLE_DOG__PREFAB_NAME = "mone_single_dog",
    SINGLE_DOG__PREFAB_CHINESE_NAME = "单身狗",

    -- 施肥瓦器人常量
    MONE_FERTILIZER_BOT__RANGE = 15,              -- 施肥检测半径（单位）
    MONE_FERTILIZER_BOT__MAX_TARGETS = 10,        -- 最多同时处理的目标数量
    MONE_FERTILIZER_BOT__SCAN_INTERVAL = 5,         -- 扫描间隔（秒）
    MONE_FERTILIZER_BOT__BATTERY_MAX = 600,         -- 最大电池/耐久（秒）
    MONE_FERTILIZER_BOT__LOW_BATTERY = 100,        -- 低电量阈值（秒）
    MONE_FERTILIZER_BOT__FUEL_DRAIN_RATE = 1,        -- 每次施肥消耗的耐久
    MONE_FERTILIZER_BOT__WALK_SPEED = 4,            -- 移动速度

}

return module