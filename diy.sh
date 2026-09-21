#!/bin/bash
set -e
export GIT_TERMINAL_PROMPT=0

# ── 修改默认主机名 ────────────────────────────────────────────
sed -i "s/ImmortalWrt/RedmiAX6-NSS/g" package/base-files/files/bin/config_generate 2>/dev/null || true

# ── 修改默认 LAN IP (改为 10.0.0.1) ───────────────────────────
sed -i 's/192\.168\.1\.1/10.0.0.1/g' package/base-files/files/bin/config_generate 2>/dev/null || true

# ── 默认语言与主题设置（Bootstrap + 简体中文） ─────────────────
# 方法1：直接写 /etc/config/luci 打包进底层
mkdir -p files/etc/config
cat > files/etc/config/luci << 'LUCIEOF'
config core main
	option lang zh-cn
	option mediaurlbase /luci-static/bootstrap
	option resourcebase /luci-static/resources
LUCIEOF

# 方法2：UCI defaults 脚本（开机首次启动时再次强制写入）
mkdir -p files/etc/uci-defaults
cat > files/etc/uci-defaults/99-set-lang.sh << 'EOF'
#!/bin/sh
uci -q set luci.main.lang=zh-cn
uci -q set luci.main.mediaurlbase='/luci-static/bootstrap'
uci commit luci
exit 0
EOF
chmod +x files/etc/uci-defaults/99-set-lang.sh

echo "[DIY] 主机名(RedmiAX6-NSS) / IP(10.0.0.1) / 中文语言(zh-cn) 已成功设置！"
