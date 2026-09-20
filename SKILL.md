---
name: codex-model-routing
description: Route coding work among Luna, Terra, and Sol. Before substantive work, compare the task recommendation with verified runtime model and effort when available; request a main-task switch or explicit subagent approval when they do not match.
---

# Codex Model Routing

Choose the least expensive model and reasoning effort that can complete the work reliably. Re-evaluate when a follow-up request changes the task type, complexity, or risk. Pure conversation, clarification, confirmation, and status replies do not need routing.

| Task | Model | Reasoning effort |
| --- | --- | --- |
| Find files and call sites, explain one function, organize logs, or make mechanical small edits | Luna (`gpt-5.6-luna`) | `low`; use `medium` when the material is large or mildly ambiguous |
| Everyday feature work, routine bug fixes, adding tests, or ordinary code review | Terra (`gpt-5.6-terra`) | `medium`; use `high` for complicated logic |
| Hard-to-locate bugs, concurrency or state problems, cross-module changes, critical code review, or architecture design | Sol (`gpt-5.6-sol`) | `high`; use `xhigh` only when the complexity or risk clearly requires it |

## Trusted runtime information

- A `UserPromptSubmit` hook can inject `codex-model-routing runtime: active_model=...` from the event's `model` field. Treat that as the current model for the turn. The hook does not expose the current reasoning effort. If the hook is absent or reports `unavailable`, the model is unknown.
- A host that starts the turn can provide both trusted values through Codex App Server `turn/start`: `model` and `effort`. Only current-turn host data can verify the effort. This skill cannot call `turn/start` to rewrite an already running turn.
- Do not treat `config.toml`, a model's default effort, an older transcript, a user's statement, or a hook output containing only the model as proof of the current effort. Do not infer `active_effort=unavailable` from a default value or treat a planned subagent configuration as the parent task's configuration.

## Preflight before task work

Before the first search, tool call, edit, review, test, or delegation for every substantive request, determine the recommended combination from the table and compare it with trusted runtime information.

1. If the parent task's model and effort are both trusted and match the recommendation, continue with the parent task.
2. If both values are trusted but do not match, state the current and recommended combinations. Ask whether the user wants to switch the parent task in the desktop app and send a new message, or approve a subagent with the specified combination. Do not claim that a switch succeeded until a new turn reports the new values.
3. If the model is known from the hook but the effort is not verifiable, say so explicitly. Do not silently treat it as a match. Ask the user either to use a host that supplies both values or to approve a subagent with the recommended model and effort.
4. If neither value is trusted, stop at the routing decision. Do not search, browse, edit, test, or delegate.

Before every subagent launch, state its model, effort, scope, and additional cost, then obtain approval for that launch. Pass both model and effort explicitly. If the launch tool cannot accept both values or the launch fails, stop and report the limitation. Summarize the subagent's result in the parent task and re-route if the task changes.

## Recovery when runtime information is missing

If a new turn does not contain `codex-model-routing runtime: active_model=...`:

1. Restart Codex so newly added skills and hooks can load.
2. In Codex CLI, run `/hooks` and review or trust the `UserPromptSubmit` hook that runs this skill's `scripts/current_model.ps1`. A file existing on disk does not prove that the hook ran.
3. Send a new substantive request and run the preflight again. If `active_model` is still absent, do not guess from configuration files.

If `active_model=gpt-5.6-sol` is present but `active_effort=unavailable`, do not repeatedly ask the user to switch the desktop setting and send “continue”; that path cannot verify the effort automatically. Ask for explicit approval to start a `Sol (high)` subagent, for example: `The parent model is verified as Sol, but the effort is not exposed. Approve a Sol (high) subagent for this task?` A reply of “continue” alone is not approval to launch that subagent.

To verify both values for the parent task itself, the host must start the turn with `model=gpt-5.6-sol` and `effort=high`. A normal desktop turn does not expose the effort field to this skill.

## Boundaries

- This skill guides routing; it cannot force the host to load a hook, expose effort, or switch an active turn. When the parent effort is unknown, the skill cannot guarantee that the parent avoided a high-cost mode. A low-cost subagent does not cancel the parent's usage.
- Never use `max`, `ultra`, `ultimate`, or any unlisted high-cost mode automatically. Explain why it is needed and obtain explicit user approval first. Treat `ultra` as subject to the same approval gate as the user's “Ultimate” mode.
- Do not enable a new model automatically. If a new model appears or an existing model's role changes, propose a complete revised allocation with its efficiency and cost tradeoffs, wait for confirmation, and then update this skill.
- Do not invent exact prices, quotas, or usage figures from model names. Fetch current official usage or pricing information when those figures are needed.

## Acceptance checks

- With trusted `Luna low`, a file-finding task can proceed directly. With only the hook's Luna model and no trusted effort, report that the effort is unverified.
- With trusted `Terra medium`, routine implementation can proceed. With trusted `Terra high` for a task recommended for Luna low, ask whether to switch the parent task or approve a specified subagent.
- Every subagent request contains an explicit model and effort and is launched only after approval.
- “I switched”, “continue”, or “I choose Sol high” are user statements, not runtime proof. Unless the host supplies both fields, keep the task in the unverified state.
