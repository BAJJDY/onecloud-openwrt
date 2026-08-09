module("luci.controller.onecloud_led", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/onecloud-led") then
        return
    end
    entry({"admin", "system", "onecloud_led"}, cbi("onecloud_led"), _("LED 控制"), 90)
end
