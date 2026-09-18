## Browser Automation

- In Codex Desktop, automatically use the installed Browser plugin (`@Browser`) for tasks that require opening, navigating, inspecting, testing, screenshotting, or verifying web pages, even when the user does not mention the plugin explicitly.
- Prefer the Browser plugin and the in-app browser over the standalone `agent-browser` skill whenever the Browser plugin is available.
- Use `agent-browser` only when the Browser plugin is unavailable or cannot handle the target, and briefly state the reason before falling back.
- Use Chrome instead when the task specifically requires an existing signed-in browser session, cookies, extensions, or the user's current Chrome tabs.
