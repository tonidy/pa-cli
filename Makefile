# Makefile for pa - a simple password manager

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin

RELEASE_DATE=$(shell git log -1 --format=%cd --date=short)
GIT_TAG:=$(shell git describe --tags)
GIT_COMMIT:=$(shell git rev-parse --short HEAD)
GIT_STATUS:=$(shell git status --porcelain)

# Development version handling
ifneq ($(GIT_STATUS),)
    VERSION_STRING=$(GIT_TAG)-dirty
    RELEASE_DATE_STRING=development
else
    VERSION_STRING=$(GIT_TAG)
    RELEASE_DATE_STRING=$(RELEASE_DATE)
endif

.PHONY: install uninstall test clean install-user verify help test-vars

.DEFAULT_GOAL := help

help:
	@echo "pa - a simple password manager"
	@echo ""
	@echo "Available targets:"
	@echo "  install       - Install pa to $(BINDIR) (requires sudo)"
	@echo "  install-user  - Install pa to ~/.local/bin"
	@echo "  uninstall     - Remove pa from $(BINDIR)"
	@echo "  test          - Run syntax and functionality tests"
	@echo "  test-vars     - Show version variables and development status"
	@echo "  verify        - Verify installation and dependencies"
	@echo "  clean         - Clean up test files"
	@echo "  help          - Show this help message"

install:
	@echo "Installing pa to $(BINDIR)..."
	@mkdir -p $(BINDIR)
	@sed -e 's/PA_VERSION="__VERSION__"/PA_VERSION="$(VERSION_STRING)"/g' -e 's/PA_RELEASE_DATE="__RELEASE_DATE__"/PA_RELEASE_DATE="$(RELEASE_DATE_STRING)"/g' -e 's/PA_COMMIT="__COMMIT__"/PA_COMMIT="$(GIT_COMMIT)"/g' pa > $(BINDIR)/pa
	@chmod +x $(BINDIR)/pa
	@echo "pa installed successfully to $(BINDIR)/pa"
	@echo ""
	@echo "Make sure the following dependencies are installed:"
	@echo "  Platform-specific installation:"
	@echo "  macOS:    brew install age fzf age-plugin-se"
	@echo "  Linux:    apt install age fzf libsecret-tools"
	@echo "  Windows:  choco install age fzf  (or scoop install age fzf)"
	@echo "  Optional: age-plugin-yubikey (YubiKey support on all platforms)"

uninstall:
	@echo "Removing pa from $(BINDIR)..."
	@rm -f $(BINDIR)/pa
	@echo "pa uninstalled successfully"

test:
	@echo "Running syntax check..."
	@sh -n pa
	@echo "Syntax check passed!"
	@echo ""
	@echo "Testing help output..."
	@./pa
	@echo ""
	@echo "All tests passed!"

clean:
	@echo "Cleaning up test files..."
	@rm -rf /tmp/pa-*
	@echo "Clean complete!"

# Install to user's local bin directory
install-user:
	@echo "Installing pa to ~/.local/bin..."
	@mkdir -p ~/.local/bin
	@sed -e 's/PA_VERSION="__VERSION__"/PA_VERSION="$(VERSION_STRING)"/g' -e 's/PA_RELEASE_DATE="__RELEASE_DATE__"/PA_RELEASE_DATE="$(RELEASE_DATE_STRING)"/g' -e 's/PA_COMMIT="__COMMIT__"/PA_COMMIT="$(GIT_COMMIT)"/g' pa > ~/.local/bin/pa
	@chmod +x ~/.local/bin/pa
	@echo "pa installed successfully to ~/.local/bin/pa"
	@echo ""
	@echo "Make sure ~/.local/bin is in your PATH:"
	@echo "  echo 'export PATH=\"\$$HOME/.local/bin:\$$PATH\"' >> ~/.bashrc"
	@echo "  echo 'export PATH=\"\$$HOME/.local/bin:\$$PATH\"' >> ~/.zshrc"

# Verify installation
verify:
	@echo "Verifying pa installation..."
	@which pa >/dev/null 2>&1 && echo "✓ pa found in PATH" || echo "✗ pa not found in PATH"
	@command -v age >/dev/null 2>&1 && echo "✓ age found" || echo "✗ age not found - see README for platform-specific installation"
	@command -v fzf >/dev/null 2>&1 && echo "✓ fzf found" || echo "✗ fzf not found - see README for platform-specific installation"
	@command -v age-plugin-se >/dev/null 2>&1 && echo "✓ age-plugin-se found (macOS)" || echo "ℹ age-plugin-se not found (macOS only)"
	@command -v secret-tool >/dev/null 2>&1 && echo "✓ secret-tool found (Linux)" || echo "ℹ secret-tool not found (Linux only)"
	@command -v powershell.exe >/dev/null 2>&1 && echo "✓ PowerShell found (Windows)" || echo "ℹ PowerShell not found (Windows only)"
	@command -v git >/dev/null 2>&1 && echo "✓ git found" || echo "✗ git not found"

test-vars:
	@echo "RELEASE_DATE: $(RELEASE_DATE)"
	@echo "GIT_TAG: $(GIT_TAG)"
	@echo "GIT_COMMIT: $(GIT_COMMIT)"
	@echo "GIT_STATUS: '$(GIT_STATUS)'"
	@echo "VERSION_STRING: $(VERSION_STRING)"
	@echo "RELEASE_DATE_STRING: $(RELEASE_DATE_STRING)"
