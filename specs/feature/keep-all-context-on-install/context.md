# Overview

Preserve all existing files in `.contextual/` during reinstall. Don't overwrite any user data.

# Scope

- **Changes**: Modify `scripts/install.sh` in the `copy_contextual_files()` function (lines 311-361)
- **Requirements**: Check file existence before copying to never overwrite existing files
- **Boundaries**: Command files still get updated (intentional behavior)

# Tasks

- [x] Check file existence before copying (macOS-compatible approach instead of `cp -n`)
- [x] Test that fresh install and reinstall both work correctly

# Additional Tasks

- [x] change `SPECIFY_DIR: ./specs` to `SPECIFY_DIR: specs` for the root reference in all command files
- [x] `commands/merge.md` remove reference to `SPECIFY_DIR` and only use the changes. But look for context.md file changes and read those specifcally. 
- [x] `commands/contextualize.md` remove reference to `CONTEXTUAL_ROOT` and only use the changes. Create a `.contextual/context/` folder for additional files if they don't exist. If the user input is empty then create technology.md, product.md, and domains.md files and reference those in the `CONTEXT_ROOT` file.
- [x] Update MERGE_TEMPLATE in config to match `commands/merge.md`


# Additional Install Tasks

- [x] Allow the user to include specific commands during install (e.g., --include specify.md,implement.md,commit.md)
- [x] Update tests to check for core functionality defined in ./README.md and inferred from `install.sh` script