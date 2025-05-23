#!/bin/bash
# 修改默认IP
sed -i 's/192.168.1.1/192.168.124.88/g' package/base-files/files/bin/config_generate

# 修改默认IP和密码
sed -i 's/192.168.1.1/192.168.124.88/g' package/base-files/files/bin/config_generate
sed -i 's/root::0:0:99999:7:::/root:$1$pulu$pulu:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# 调整根目录容量（RK3328通常为EMMC存储）
sed -i 's/option overlay_size.*/option overlay_size 8192/g' target/linux/rockchip/image/Makefile

# 针对RK3328的优化（可选）
echo 'CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y' >> .config
echo 'CONFIG_ARM64_CRYPTO=y' >> .config

# 更改默认 Shell 为 fish
sed -i 's/\/bin\/ash/\/usr\/bin\/fish/g' package/base-files/files/etc/passwd

# 修改frpc
rm -rf feeds/luci/applications/luci-app-frpc
git clone https://github.com/yhl452493373/luci-app-frpc.git package/luci-app-frpc
#修改homeproxy
rm -rf  feeds/luci/applications/luci-app-homeproxy
#git clone https://github.com/bulianglin/homeproxy package/homeproxy
#git clone https://github.com/muink/luci-app-homeproxy package/homeproxy
git clone -b dev/main https://github.com/muink/homeproxy.git package/homrproxy  #使用dev/main分支

# 添加额外插件
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome

# Themes
git clone --depth=1 -b master https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
#git clone --depth=1 -b master https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
#git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
#git clone --depth=1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
#git clone https://github.com/gngpp/luci-theme-design.git package/luci-theme-design
#git clone https://github.com/gngpp/luci-app-design-config.git package/luci-app-design-config
#svn export https://github.com/haiibo/packages/trunk/luci-theme-atmaterial package/luci-theme-atmaterial
#svn export https://github.com/haiibo/packages/trunk/luci-theme-opentomcat package/luci-theme-opentomcat
#svn export https://github.com/haiibo/packages/trunk/luci-theme-netgear package/luci-theme-netgear

# x86 型号只显示 CPU 型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/emortal/autocore/files/x86/autocore

# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/emortal/autocore/files/*/index.htm

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/emortal/default-settings/files/99-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by LoogCP/g" package/emortal/default-settings/files/99-default-settings

# 修复 hostapd 报错
#cp -f $GITHUB_WORKSPACE/scripts/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch

./scripts/feeds update -a
./scripts/feeds install -a -f
