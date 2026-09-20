# Codex 模型路由

English | 简体中文

根据任务复杂度和风险，在 GPT-5.6 Luna、Terra 和 Sol 之间分配编程任务。

## 安装

使用 Skills CLI 将此 skill 安装到 Codex 全局目录：

```powershell
npx -y skills add rosenthul/CodexModelRoute -a codex -g -y
```

安装完成后请重启 Codex，使它发现新 skill。

## 模型分工

- **Luna**：查找文件和调用点、解释单个函数、整理日志、机械性小改动。
- **Terra**：日常功能开发、常规 bug 修复、补测试、一般代码审查。
- **Sol**：难定位的 bug、并发或状态问题、跨模块改动、关键代码审查、架构设计。

本 skill 不会自动启用 `max`、`ultra`、`ultimate` 或其他未列出的高消耗模式。出现新模型时，也必须先明确审查并确认新的分工规则。

## 运行时模型 hook

可选的 `scripts/current_model.ps1` hook 可以通过 `UserPromptSubmit` hook 注入当前模型。该 hook 无法获取桌面端当前推理档位，因此本 skill 不会把缺失的档位当作已核验。

如需完整核验运行时配置，请使用能在启动轮次时同时传入 `model` 和 `effort` 的宿主，或者批准启动一个明确指定模型和档位的子代理。

## 仓库结构

```text
SKILL.md
README.md
README.zh-CN.md
scripts/current_model.ps1
```

`SKILL.md` 包含路由规则。PowerShell 脚本是可选的，只负责注入运行时模型，不会自动修改用户的 Codex hook 配置。
