# ImmortalWrt 云编译固件

基于 [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) 的定制固件，支持每周自动构建，也可自行在 GitHub 上构建。

## 下载固件

前往 [Releases](https://github.com/bigbugcc/Immortalwrts/releases)，选择对应设备的最新发布，在 **Assets** 中下载固件。

| 设备 ID | 目标 | 手动构建状态 | 定时发布状态 |
| --- | --- | --- | --- |
| `x86_64` | x86-64 generic，生成 ISO、VMDK 与 EXT4 镜像 | [![手动构建状态](https://github.com/bigbugcc/Immortalwrts/actions/workflows/manual-build.yml/badge.svg?branch=main)](https://github.com/bigbugcc/Immortalwrts/actions/workflows/manual-build.yml?query=branch%3Amain) | [![定时发布状态](https://github.com/bigbugcc/Immortalwrts/actions/workflows/schedule-release.yml/badge.svg?branch=main)](https://github.com/bigbugcc/Immortalwrts/actions/workflows/schedule-release.yml?query=branch%3Amain) |
| `nn6000-v2` | Link NN6000 v2，`qualcommax/ipq60xx` | [![手动构建状态](https://github.com/bigbugcc/Immortalwrts/actions/workflows/manual-build.yml/badge.svg?branch=main)](https://github.com/bigbugcc/Immortalwrts/actions/workflows/manual-build.yml?query=branch%3Amain) | [![定时发布状态](https://github.com/bigbugcc/Immortalwrts/actions/workflows/schedule-release.yml/badge.svg?branch=main)](https://github.com/bigbugcc/Immortalwrts/actions/workflows/schedule-release.yml?query=branch%3Amain) |

徽章显示 `main` 分支对应工作流的整体状态；点击可查看各设备的构建结果。

## 刷写与登录

1. 备份现有配置，按设备或虚拟化平台的刷写方式安装对应镜像；已有兼容固件可在管理页面选择适用的升级镜像。
2. 电脑连接设备 LAN 口，将电脑设为自动获取 IP，浏览器打开 **http://192.168.10.1**。
3. 按登录页面提示进入后台，设置管理密码，再配置网络和所需服务。保留旧配置升级时，管理地址可能沿用原设置。

**请核对设备型号与镜像用途，勿跨型号刷写；首次安装不确定时，先查阅设备的刷机及恢复说明。**

## 自行构建

1. Fork 本仓库，在自己的仓库中打开 **Actions**，按提示启用工作流。
2. 选择 **Manual ImmortalWrt Build → Run workflow**。
3. `device` 选择设备，`all` 表示全部；`branch` 留空使用默认的 `master`，`cache_mode` 保持 `readwrite` 即可。
4. 需要发布到自己仓库的 Releases 时，勾选 `upload_release`，然后开始构建。
5. 构建成功后，在该次运行页面的 **Artifacts** 中下载 `ImmortalWrt_设备_时间`；勾选发布后也可从 Releases 下载。

## LuCI 插件

默认配置选择以下应用，表中名称均省略 `luci-app-` 前缀；实际包含项以对应发布的固件包清单为准。

| 用途 | 插件 |
| --- | --- |
| 代理服务 | `passwall2`（Xray）、`homeproxy` |
| 文件与共享 | `samba4`（局域网共享）、`vsftpd`（FTP）、`filebrowser-go`（文件管理）、`openlist`（文件列表） |
| 网络管理 | `firewall`（防火墙）、`upnp`（自动端口映射）、`arpbind`（IP/MAC 绑定）、`appfilter`（应用过滤） |
| 远程访问 | `ttyd`（网页终端）、`frpc`（内网穿透客户端） |
| 唤醒与定时 | `wol`（网络唤醒）、`timewol`（定时唤醒）、`autoreboot`（定时重启） |
| 状态与存储 | `netdata`（性能监控）、`diskman`（磁盘管理） |
| 其他服务 | `uhttpd`（Web 服务设置）、`vlmcsd`（KMS 服务） |

主题：Argon、Bootstrap，支持简体中文界面。

## 安装插件

固件默认使用南京大学 ImmortalWrt 镜像源，可在后台的软件包页面刷新列表并安装软件。保留旧配置升级时，软件源可能沿用旧设置。

发布文件中的 `luci-apps-设备-时间.tar.gz` 是可选的软件包合集，**不是固件镜像**。下载后用配套的 `.sha256` 文件校验：

```sh
sha256sum -c luci-apps-设备-时间.tar.gz.sha256
```

将命令中的文件名替换为实际下载名称，再解压并按需安装应用及依赖，不要一次安装全部包。合集仅适用于**同一次发布的固件**，不能跨版本混用；第三方插件不一定在镜像源中，内核模块也必须与固件版本匹配。
