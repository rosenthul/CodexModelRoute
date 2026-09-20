# Codex Model Routing / Codex 模型路由

Routes coding work among GPT-5.6 Luna, Terra, and Sol according to task complexity and risk.

根据任务复杂度和风险，在 GPT-5.6 Luna、Terra 和 Sol 之间分配编程任务。

## Install / 安装

Install this skill globally for Codex with the Skills CLI:

使用 Skills CLI 将此 skill 安装到 Codex 全局目录：

```powershell
npx -y skills add rosenthul/CodexModelRoute -a codex -g -y
```

Restart Codex after installation so the skill is discovered.

安装完成后请重启 Codex，使它发现新 skill。

## Model policy / 模型分工

- **Luna**: file and call-site discovery, single-function explanations, log organization, and mechanical small edits.
- **Luna**：查找文件和调用点、解释单个函数、整理日志、机械性小改动。

- **Terra**: everyday feature work, routine bug fixes, tests, and ordinary code review.
- **Terra**：日常功能开发、常规 bug 修复、补测试、一般代码审查。

- **Sol**: hard bugs, concurrency or state issues, cross-module changes, critical reviews, and architecture design.
- **Sol**：难定位的 bug、并发或状态问题、跨模块改动、关键代码审查、架构设计。

The skill does not automatically enable `max`, `ultra`, `ultimate`, or other unlisted high-cost modes. A new model also requires an explicit review of the routing policy before use.

本 skill 不会自动启用 `max`、`ultra`、`ultimate` 或其他未列出的高消耗模式。出现新模型时，也必须先明确审查并确认新的分工规则。

## Runtime model hook / 运行时模型 hook

The optional `scripts/current_model.ps1` hook can inject the active model into a `UserPromptSubmit` hook. The hook does not expose the desktop app's current reasoning effort, so the skill never treats a missing effort value as verified.

可选的 `scripts/current_model.ps1` hook 可以通过 `UserPromptSubmit` hook 注入当前模型。该 hook 无法获取桌面端当前推理档位，因此本 skill 不会把缺失的档位当作已核验。

For full runtime verification, use a host that starts the turn with both `model` and `effort` values, or approve a subagent whose model and effort are specified explicitly.

如需完整核验运行时配置，请使用能在启动轮次时同时传入 `model` 和 `effort` 的宿主，或者批准启动一个明确指定模型和档位的子代理。

## Repository layout / 仓库结构

```text
SKILL.md
README.md
scripts/current_model.ps1
```

`SKILL.md` contains the routing rules. The PowerShell script is optional and only supports runtime model injection; it does not install itself into the user's Codex hooks automatically.

`SKILL.md` 包含路由规则。PowerShell 脚本是可选的，只负责注入运行时模型，不会自动修改用户的 Codex hook 配置。
