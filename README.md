# pa cli

**a simple password manager**

## About

This is a hard fork of the original [pa](https://github.com/biox/pa) (see https://passwordass.org) by [biox](https://github.com/biox), enhanced with:

- Cross-platform support (macOS, Linux, Windows)
- OS-native credential storage integration
- Apple Secure Enclave support (Touch ID/Face ID authentication) from [remko](https://github.com/remko/age-plugin-se)
- Fuzzy search integration with fzf
- Improved installation and setup process

## Features

- encryption implemented using [age](https://age-encryption.org)
- automatic key generation
- automatic git tracking
- multiple identity/recipient support
- cross-platform support: macOS, Linux, Windows (NEW)
- OS-native credential storage integration (NEW)
- Apple Secure Enclave integration (NEW)
- fuzzy search with fzf (NEW)
- written in portable POSIX shell
- simple to extend
- only ~580 lines of code (enhanced from original ~160)
- pronounced "pah" - as in "papa"

## Installation

> **Note:** This is a hard fork with additional features  
> For the original pa, see: https://github.com/biox/pa

### Install dependencies by platform:

#### macOS (Homebrew)
```bash
brew install age fzf age-plugin-se
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install age fzf libsecret-tools
```

#### Linux (Arch)
```bash
sudo pacman -S age fzf libsecret
```

#### Windows (Chocolatey)
```bash
choco install age fzf
```

#### Windows (Scoop)
```bash
scoop install age fzf
```

### Installation Options

#### Option 1: Install using Makefile (recommended)
```bash
sudo make install              # Install to /usr/local/bin
make install-user              # Install to ~/.local/bin
```

#### Option 2: Manual installation
```bash
# Install pa to /usr/local/bin
sudo cp pa /usr/local/bin/
sudo chmod +x /usr/local/bin/pa

# Or install to your local bin directory
mkdir -p ~/.local/bin
cp pa ~/.local/bin/
chmod +x ~/.local/bin/pa
# Make sure ~/.local/bin is in your PATH
```

## Dependencies

### Required
- age (cross-platform)
- age-keygen (cross-platform)
- git (optional, cross-platform)
- fzf (optional, for fuzzy search support)

### Platform-specific (optional)
- **macOS:** age-plugin-se (Secure Enclave), security (Keychain)
- **Linux:** secret-tool (libsecret for credential storage)
- **Windows:** PowerShell (for Credential Manager integration)
- **All platforms:** age-plugin-yubikey (YubiKey support)

## Usage

```
pa
  a simple password manager

commands:
  [a]dd  [name] - Add a password entry.
  [d]el  [name] - Delete a password entry.
  [e]dit [name] - Edit a password entry with vi.
  [f]ind [cmd]  - Fuzzy search passwords with fzf.
  [g]it  [cmd]  - Run git command in the password dir.
  [l]ist        - List all entries.
  [s]how [name] - Show password for an entry.

env vars:
  data directory:   export PA_DIR=~/.local/share/pa/passwords
  password length:  export PA_LENGTH=50
  password pattern: export PA_PATTERN=A-Za-z0-9-_
  disable tracking: export PA_NOGIT=
```

## Command Examples

```bash
$ pa add test
generate a password? [y/N]: y
saved 'test' to the store.

$ pa list
test

$ pa show test
vJwKuEBtxBVvdR-xppTdfofIei0oLlkoSK4OCSP2bMEBsP6ahM

$ pa edit test
<opens $EDITOR or vi>

$ pa del test
delete password 'test'? [y/N]: y

$ pa git log --oneline
bbe85dc (HEAD -> main) delete 'test'
b597c04 edit 'test'
cba20cc add 'test'
ef76f7e initial commit

$ pa find
<opens fzf to select password, then shows it>

$ pa find show
<opens fzf to select password, then shows it>

$ pa find edit
<opens fzf to select password, then edits it>

$ pa find del
<opens fzf to select password, then deletes it>
```

## FAQ

### How does this differ from the original pa?

This fork adds:
- Cross-platform support (macOS, Linux, Windows)
- OS-native credential storage integration
- Apple Secure Enclave support for Touch ID/Face ID authentication
- Fuzzy search with fzf for interactive password selection
- Enhanced installation process with Makefile
- Better documentation and setup instructions

### How does this differ from pass, passage, etc?

pa is smaller. simpler. cleaner. plainer.  
harder. better. faster. stronger.  
more than ever, hour after hour  
work is never over

### Is pa secure?

If you would like to understand the security characteristics of pa, please read biox's [blog post](https://j3s.sh/thought/storing-passwords-with-age.html), and biox's [explanation](https://github.com/biox/pa/issues/10#issuecomment-1369225383).

### Why make this?

See this [blog post](https://j3s.sh/thought/storing-passwords-with-age.html).

### Where are my keys?

Probably the default locations:
- `~/.local/share/pa/identities`
- `~/.local/share/pa/recipients`

### How do I use Apple Secure Enclave?

Install age-plugin-se:
```bash
brew install age-plugin-se
```

When you first run pa, it will offer to generate a secure enclave identity with Touch ID protection.

Decryption will require Touch ID/Face ID authentication.

Note from remko's documentation[9]:

> ℹ️ The private key is bound to the secure enclave of your machine, so it cannot be transferred to another machine. This also means that you should take the necessary precautions, and make sure you also encrypt any long-term data to an alternate backup key.

### How do I use fuzzy search?

Install fzf:
```bash
brew install fzf
```

Then use `pa find` to search and select passwords interactively. You can combine it with commands:
- `pa find show` - search and show password
- `pa find edit` - search and edit password
- `pa find del` - search and delete password

### How does cross-platform support work?

pa automatically detects your operating system and uses:
- **macOS:** Keychain for credential storage
- **Linux:** libsecret/secret-tool for credential storage
- **Windows:** Credential Manager via PowerShell

Set `PA_NO_KEYRING=1` to disable credential storage and use traditional file-based keys only.

### Where are my passwords?

Probably the default location:
- `~/.local/share/pa/passwords`

### How do I rename a password?

```bash
cd ~/.local/share/pa/passwords
mv foo.age bar.age
```

## Credits

- This fork is based on [pa](https://github.com/biox/pa) by [biox](https://github.com/biox)
- pa was originally forked from [pash](https://github.com/dylanaraps/pash) by [dylanaraps](https://github.com/dylanaraps)
- [age](https://age-encryption.org) is a project by [Filippo Valsorda](https://filippo.io)
- [age-plugin-se](https://github.com/remko/age-plugin-se) by [remko](https://github.com/remko) enables Apple Secure Enclave support
- [fzf](https://github.com/junegunn/fzf) by [junegunn](https://github.com/junegunn) provides fuzzy search functionality

## References

1. [age-encryption.org](https://age-encryption.org)
2. [Storing passwords with age](https://j3s.sh/thought/storing-passwords-with-age.html)
3. [Security explanation](https://github.com/biox/pa/issues/10#issuecomment-1369225383)
4. [pash](https://github.com/dylanaraps/pash)
5. [dylanaraps](https://github.com/dylanaraps)
6. [Filippo Valsorda](https://filippo.io)
7. [Original pa](https://github.com/biox/pa)
8. [biox](https://github.com/biox)
9. [age-plugin-se](https://github.com/remko/age-plugin-se)
10. [fzf](https://github.com/junegunn/fzf)
