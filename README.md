# ImmortalWrt 云编译固件

[ImmortalWrt](https://github.com/immortalwrt/immortalwrt) 构建下列设备：

| 设备 ID | 目标 |
| --- | --- |
| `x86_64` | x86-64 generic，生成 ISO、VMDK 与 EXT4 镜像 |
| `nn6000-v2` | Link NN6000 v2，`qualcommax/ipq60xx` |


## ActionInfo

- 手动构建与每周定时发布
- 由 `manifests/builds.json` 驱动的构建矩阵和工作流一致性检查
- `dl` 与 `.ccache` 缓存，按设备、分支和配置内容隔离
- 分阶段编译、失败回退并上传 Artifact；可选 GitHub Release
- 默认管理地址 `192.168.10.1`

## 使用

在 GitHub Actions 中运行：

- `Manual ImmortalWrt Build`：选择 `x86_64`、`nn6000-v2` 或 `all`；可临时覆盖上游分支。
- `Scheduled ImmortalWrt Release`：默认每周构建两个设备并创建 Release；手动触发时可以用逗号分隔设备 ID。

固件上传到 Release 前会同时作为 Action Artifact 保存。不要将 x86 与 NN6000 v2 的镜像交叉刷写。

## 本地校验

```powershell
node scripts/openwrts.mjs validate-manifest
node scripts/openwrts.mjs generate-workflows --check
node scripts/openwrts.mjs resolve-matrix --device nn6000-v2
```

改动 `manifests/builds.json` 后运行 `node scripts/openwrts.mjs generate-workflows`，再提交生成的两个入口工作流。

## 目录

```text
.github/workflows/  手动、定时与复用构建工作流
configs/targets/    两个硬件目标配置
configs/apps/       共用的 LuCI 与功能包选择
feeds/              ImmortalWrt 专用第三方 feeds
packages/           ImmortalWrt 专用第三方包克隆
manifests/          唯一上游和设备构建矩阵
scripts/            环境、源码、配置与编译脚本
```
