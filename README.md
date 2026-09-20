# Codex Model Routing

Routes coding work among GPT-5.6 Luna, Terra, and Sol according to task complexity and risk.

## Install

Install this skill globally for Codex with the Skills CLI:

```powershell
npx -y skills add rosenthul/CodexModelRoute -a codex -g -y
```

Restart Codex after installation so the skill is discovered.

## Model policy

- Luna: file and call-site discovery, single-function explanations, log organization, and mechanical small edits.
- Terra: everyday feature work, routine bug fixes, tests, and ordinary code review.
- Sol: hard bugs, concurrency or state issues, cross-module changes, critical reviews, and architecture design.

The skill does not automatically enable `max`, `ultra`, `ultimate`, or other unlisted high-cost modes. A new model also requires an explicit review of the routing policy before use.

## Runtime model hook

The optional `scripts/current_model.ps1` hook can inject the active model into a `UserPromptSubmit` hook. The hook does not expose the desktop app's current reasoning effort, so the skill never treats a missing effort value as verified.

For full runtime verification, use a host that starts the turn with both `model` and `effort` values, or approve a subagent whose model and effort are specified explicitly.
