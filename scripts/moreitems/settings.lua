local this = {}

this.DEBUG = true -- 正常开发的项目在自动化部署的时候可以用脚本替换 DEBUG -> false

this.TEST_ENABLED = false -- 启动测试用例的执行，默认应该是 false，通过命令修改其为 true，测试完毕再修改为 false（这意味着测试用例的运行环境必须是个沙盒，至少让崩溃后可以进入 __exit__ 逻辑）

this.BASE_DIR = "D:\\games\\Steam\\steamapps\\common\\Don't Starve Together\\mods\\MoreItems" -- 如何获取？好像有点困难
this.SOURCE_DIR = this.BASE_DIR .. "\\" .. "scripts"

return this
