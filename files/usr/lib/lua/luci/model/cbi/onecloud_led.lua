local m = Map("onecloud-led", translate("LED 控制"),
    translate("控制玩客云前面板指示灯的开关状态。"))

local s = m:section(TypedSection, "led", "")
s.addremove = false
s.anonymous = true

local state = s:option(ListValue, "state", translate("LED 状态"))
state:value("1", translate("开启"))
state:value("0", translate("关闭"))
state.default = "1"

function state.write(self, section, value)
    Value.write(self, section, value)
    luci.util.exec("/usr/bin/onecloud-led.sh " .. (value == "1" and "on" or "off"))
end

return m
