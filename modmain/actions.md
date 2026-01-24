--[[SCENE = --args: inst, doer, actions, right					--场景		(inst:指针指向实体, doer:行为人实体, right:左键行为)
USEITEM = --args: inst, doer, target, actions, right		--使用项目	(inst:指针手持实体, target:指针指向实体)
POINT = --args: inst, doer, pos, actions, right				--地面		(inst:指针手持实体(种植型), pos:指针坐标)
EQUIPPED = --args: inst, doer, target, actions, right		--装备
INVENTORY = --args: inst, doer, actions, right				--库存		(inst:指针指向实体)
ISVALID = --args: inst, action, right						--是有效的
--]]
--[[
要搭建一条传输线路，我们需要一个组件以及相应的组件动作搜集器，以及一个动作，以及动作对于的sg里的动作处理器。
组件动作，在官方制作者那里是分好了类的，不过分类并不是唯一的，同一个组件动作，可能会同时有多个类的属性。比如说Book这个组件，就是读书。
你可以在物品栏里按右键读，也可以左键拿起书，然后对着人物点左键读。虽然是同一个动作，但执行的场景不一样，前者是Inventory，也就是你的物品栏，
后者是Scene，也就是屏幕。不同的场景下，传输给组件动作搜集器的数据是不一样的。也就是说，组件动作搜集器有5种。
官方默认分为5个类，SCENE，USEITEM，POINT，EQUIPPED，INVENTORY。这里翻译一下klei论坛上的教程里，对这5个类的介绍。原作者是rezecib。
----------------
SCENE           --args: inst, doer, actions, right                                  --直接点击某个具有某个组件的物品
使用变量inst(拥有这个组件的东西），doer（做这个动作的玩家）,actions（你添加的动作会被添加到哪张动作表中去，这个参数一般会在函数参数表的尾端。
译者注：如果有right的话，在right前面)，right（是否是一个右键点击动作)。
--SCENE 动作是通过点击一个在物品栏或者世界上物品来完成的。
拥有这个组件动作的这个东西，让自己能够被点击从而执行动作，这一点与USEITEM和EQUIPPED相反，它们是让你能够点击在你的鼠标所指向的物品，
或者物品栏的物品来执行动作。一个例子是收集作物这个动作。
译者注：这里补充几句。edible这个组件，是物品可食用的组件。这个组件没有SCENE 这个组件动作搜集器，
只有USEITEM 和 INVENTORY。所以，你不能把食物放在地上，然后右键点击吃掉它（除了woodie的海狸形态，那个比较特殊，这里略过不谈）。
要吃掉食物，你只能左键拿起食物，然后对着人点击鼠标，或者把食物放到物品栏里，右键点击。
【【【【【【SCENE则就是，你能直接点击它然后完成对应动作。】】】】】】
-----------------
USEITEM         --args: inst, doer, target, actions, right                          --拿着具有某个组件的物品对着另一个物品
使用变量 inst,doer,target(被点击的东西），actions和right。USEITEM 动作是这样的，
你拿起这个物品（译者注：拥有这个组件动作的物品），
去对着世界上的某些其它的物品，就可以激活该动作，按下去就会执行这个动作，典型的例子就是拿起燃料往火坑里添火。
-----------------
POINT           --args: inst, doer, pos, actions, right                             --对着地面，或者物体
使用变量inst,doer,pos（被点击的位置)，actions和right。POINT动作可以被很多东西激活（装备一个手持物品（其它部位不行），或者将一个物品拿起来（附在鼠标上）），
【【【【但这是唯一一种对着地面而不是一个具体的物体作为变量的动作。】】】】
典型的例子有deployable组件--种植东西以及放置陷阱。另一个例子则是橙宝石法杖（闪现）。
-----------------
EQUIPPED        --args: inst, doer, target, actions, right                          --让某个特殊的物品装备时，具有对应的动作
使用变量inst,doer,target,actions,right。
【【【EQUIPPED动作是在你让某个特别的物品被装备时激活。】】】
例子：装备火把可以激活点火动作，装备铥矿斧可以砍树，装备武器可以攻击。
-----------------
INVENTORY       --args: inst, doer, actions, right                                  --点击物品栏执行的
使用变量inst,doer,actions,right。INVENTORY动作可以通过右键点击物品栏执行。例子有吃东西，装备物品，治疗等等。
--------------------
在联机版中，是通过一个名为componentactions.lua的文件来储存所有的动作搜集器，并通过AddComponentAction这个函数来添加新的动作搜集器。
]]
--[[
-----actions-----自定义动作
{
id,--动作ID
str,--动作显示名字
fn,--动作执行函数
actiondata,--其他动作数据，诸如strfn、mindistance等，可参考actions.lua
state,--关联SGstate,可以是字符串或者函数
canqueuer,--兼容排队论 allclick为默认，rightclick为右键动作
}
-----component_actions-----动作和组件绑定
{
type,--动作类型
*SCENE--点击物品栏物品或世界上的物品时执行,比如采集
*USEITEM--拿起某物品放到另一个物品上点击后执行，比如添加燃料
*POINT--装备某手持武器或鼠标拎起某一物品时对地面执行，比如植物人种田
*EQUIPPED--装备某物品时激活，比如装备火把点火
*INVENTORY--物品栏右键执行，比如吃东西

        *SCENE      testfn = function(inst,doer,actions,right)
		*USEITEM    testfn = function(inst, doer, target, actions, right)
		*POINT
		*EQUIPPED   testfn = function(inst, doer, target, actions, right)
		*INVENTORY  testfn = function(inst,doer,actions,right)
	component,--绑定的组件
	tests,--尝试显示动作，可写多个绑定在同一个组件上的动作及尝试函数
}
-----old_actions-----修改老动作
{
switch,--开关，用于确定是否需要修改
id,--动作ID
actiondata,--需要修改的动作数据，诸如strfn、fn等，可不写
state,--关联SGstate,可以是字符串或者函数
}
--]]