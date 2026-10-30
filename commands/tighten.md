---
name: tighten-code
description: Use when Dylan asks to shorten or tighten code or code docs, or invokes /tighten-code.
---
# Tighten Code

Shorten the code or code documentation the user pasted, named, or default to your last reply. Ask if unclear.

Keep every behavior, signature, type, edge case, error path, and name callers depend on, plus any caveat that would change what the reader or caller does.
Keep the original's format and voice. Source stays source in the same language; a docstring stays a docstring; project docs still sound like the project.
Cut preamble, repetition, filler, hedges, comments that restate the code, and closing summaries. Lead with the main point. Add nothing new — no behavior changes, no drive-by refactors or renames.
Aim to shorten by the provided target or 30% - 50% default.
If the text is tight, say so instead of forcing cuts.
Return only the revised text. When the user named a file, apply the edit there instead. Add one line after it only if you dropped something the reader might miss.

## Example

Before:
```ts
/**
 * This helper is responsible for taking the user ID that was passed in
 * and then looking up the corresponding user record in the database.
 * If it can't find one, it will throw an error so the caller knows.
 */
async function getUserById(userId: string) {
  const user = await db.users.findUnique({ where: { id: userId } });
  if (user === null || user === undefined) {
    throw new Error("User not found");
  }
  return user;
}
```

After:
```ts
/** Look up user by ID; throw if missing. */
async function getUserById(userId: string) {
  const user = await db.users.findUnique({ where: { id: userId } });
  if (!user) throw new Error("User not found");
  return user;
}
```
