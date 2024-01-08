#!/bin/bash

# 修改默认IP
sed -i 's/192.168.1.1/10.10.1.1/g' package/base-files/files/bin/config_generate

# 更改默认 Shell 为 zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/fish/g' package/base-files/files/etc/passwd

# TTYD 自动登录
# sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 移除要替换的包
#rm -rf feeds/packages/net/mosdns
#rm -rf feeds/packages/net/msd_lite
#rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-netgear
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-serverchan

# frp
#rm -rf feeds/packages/net/frp
#git clone https://github.com/yhl452493373/openwrt-frp.git feeds/packages/net/frp
#FRP_URL=$( curl -sL https://api.github.com/repos/fatedier/frp/releases | grep -P 'download/v[\d.]+/frp_[\d.]+_linux_amd64.tar.gz' | awk -F '"' '{print $4}' | awk 'NR==1{print}' )
#FRP_VERSION=$( echo $FRP_URL | awk -F '/' '{print $8}' | awk '{gsub(/v/,"");print $1}' )
#FRP_HASH=$( curl -sL https://codeload.github.com/fatedier/frp/tar.gz/v$FRP_VERSION | sha256sum | awk -F ' ' '{print $1}' )
# 更新frp源码到最新版本
#sed -i -e 's/^PKG_VERSION.*/PKG_VERSION:='''$FRP_VERSION'''/' feeds/packages/net/frp/Makefile
#sed -i -e 's/^PKG_HASH.*/PKG_HASH:='''$FRP_HASH'''/' feeds/packages/net/frp/Makefile

# FRP穿透
rm -rf feeds/luci/applications/luci-app-frpc
git clone https://github.com/yhl452493373/luci-app-frpc.git package/luci-app-frpc

# 添加额外插件
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
#git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan
# git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy
# git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter
git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
svn export https://github.com/Lienol/openwrt-package/trunk/luci-app-filebrowser package/luci-app-filebrowser
svn export https://github.com/Lienol/openwrt-package/trunk/luci-app-ssr-mudb-server package/luci-app-ssr-mudb-server
#svn export https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-eqos package/luci-app-eqos
# svn export https://github.com/syb999/openwrt-19.07.1/trunk/package/network/services/msd_lite package/msd_lite



# 科学上网插件
git clone --depth=1 -b main https://github.com/fw876/helloworld package/luci-app-ssr-plus
# svn export https://github.com/haiibo/packages/trunk/luci-app-vssr package/luci-app-vssr
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb package/lua-maxminddb
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
# svn export https://github.com/xiaorouji/openwrt-passwall/trunk/luci-app-passwall package/luci-app-passwall
# svn export https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 package/luci-app-passwall2
# svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash

# Themes
git clone --depth=1 -b master https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
git clone --depth=1 -b master https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth=1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
git clone -b js https://github.com/papagaye744/luci-theme-design.git package/luci-theme-design
git clone https://github.com/gngpp/luci-app-design-config.git package/luci-app-design-config
svn export https://github.com/haiibo/packages/trunk/luci-theme-atmaterial package/luci-theme-atmaterial
svn export https://github.com/haiibo/packages/trunk/luci-theme-opentomcat package/luci-theme-opentomcat
svn export https://github.com/haiibo/packages/trunk/luci-theme-netgear package/luci-theme-netgear

# 更改 Argon 主题背景
cp -f $GITHUB_WORKSPACE/images/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg



# 在线用户
svn export https://github.com/haiibo/packages/trunk/luci-app-onliner package/luci-app-onliner
sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=2s' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings
chmod 755 package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh

# x86 型号只显示 CPU 型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore

# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by Haiibo/g" package/lean/default-settings/files/zzz-default-settings

# 修复 hostapd 报错
cp -f $GITHUB_WORKSPACE/scripts/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch

# 修改 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# 取消主题默认设置
find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;

# 调整 V2ray服务器 到 VPN 菜单
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/controller/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/model/cbi/v2ray_server/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/view/v2ray_server/*.htm

./scripts/feeds update -a
./scripts/feeds install -a -f
