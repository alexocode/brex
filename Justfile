# List all commands
default:
    @just --list

# Run all tests
test:
    mix test

# Run only tests affected by recent changes (faster)
test-stale:
    mix test --stale

# Format code
format:
    mix format

# Pre-commit gate: run by the global TDD commit-msg hook
pre-commit: test-stale

# Pre-push gate: full test suite before pushing
pre-push: test
