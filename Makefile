# Makefile for pa - a simple password manager

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin

.PHONY: install uninstall test clean install-user verify help

.DEFAULT_GOAL := help

help:
	@echo "pa - a simple password manager"
	@echo ""
	@echo "Available targets:"
	@echo "  install       - Install pa to $(BINDIR) (requires sudo)"
	@echo "  install-user  - Install pa to ~/.local/bin"
	@echo "  uninstall     - Remove pa from $(BINDIR)"
	@echo "  test          - Run syntax and functionality tests"
	@echo "  verify        - Verify installation and dependencies"
	@echo "  clean         - Clean up test files"
	@echo "  help          - Show this help message"

install:
	@echo "Installing pa to $(BINDIR)..."
	@mkdir -p $(BINDIR)
	@cp pa $(BINDIR)/pa
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
	@cp pa ~/.local/bin/pa
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
