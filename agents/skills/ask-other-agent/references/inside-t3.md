# Ask another agent inside T3 Code

Follow the `t3-code-delegation` skill instead of shelling out to any CLI, with
the chosen provider and a model resolved from the live capabilities catalogue
using `SKILL.md`’s model-family preferences.

Use `interactionMode: "plan"` for an opinion. For edit work, check the
parent’s capabilities: omitting the mode inherits it, and a plan-mode parent
must leave plan mode before delegating edits.
