                   pa
        a simple password manager
         https://passwordass.org

  about
    This is a hard fork of the original pa[7] by biox[8], enhanced with:
    - Apple Secure Enclave support (Touch ID/Face ID authentication)
    - Fuzzy search integration with fzf
    - Improved installation and setup process

  features
    - encryption implemented using age[1]
    - automatic key generation
    - automatic git tracking
    - multiple identity/recipient support
    - Apple Secure Enclave integration (NEW)
    - fuzzy search with fzf (NEW)
    - written in portable posix shell
    - simple to extend
    - only ~380 lines of code (enhanced from original ~160)
    - pronounced "pah" - as in "papa"


  installation
    # Note: This is a hard fork with additional features
    # For the original pa, see: https://github.com/biox/pa

    # Install dependencies (macOS with Homebrew)
    brew install age fzf age-plugin-se

    # Option 1: Install using Makefile (recommended)
    sudo make install              # Install to /usr/local/bin
    make install-user              # Install to ~/.local/bin

    # Option 2: Manual installation
    # Install pa to /usr/local/bin
    sudo cp pa /usr/local/bin/
    sudo chmod +x /usr/local/bin/pa

    # Or install to your local bin directory
    mkdir -p ~/.local/bin
    cp pa ~/.local/bin/
    chmod +x ~/.local/bin/pa
    # Make sure ~/.local/bin is in your PATH


  dependencies
    - age
    - age-keygen
    - git (optional)
    - fzf (optional, for fuzzy search support)
    - age-plugin-se (optional, for Apple Secure Enclave support)
    - age-plugin-yubikey (optional, for YubiKey support)


  usage
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


  command examples
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


  faq
    > how does this differ from the original pa?

      This fork adds:
      - Apple Secure Enclave support for Touch ID/Face ID authentication
      - Fuzzy search with fzf for interactive password selection
      - Enhanced installation process with Makefile
      - Better documentation and setup instructions

    > how does this differ from pass, passage, etc?

      pa is smaller. simpler. cleaner. plainer.
      harder. better. faster. stronger.
      more than ever, hour after hour
      work is never over

    > is pa secure?

      if you would like to understand the
      security characteristics of pa, please
      read my blog post[2], and my explanation[3].

    > why u make this?

      see [2].

    > where are my keys?

      probably the default locations:
        ~/.local/share/pa/identities
        ~/.local/share/pa/recipients

    > how do i use apple secure enclave?

      install age-plugin-se:
        brew install age-plugin-se

      when you first run pa, it will offer to generate
      a secure enclave identity with touch id protection.

      decryption will require touch id/face id authentication.

    > how do i use fuzzy search?

      install fzf:
        brew install fzf

      then use 'pa find' to search and select passwords
      interactively. you can combine it with commands:
        pa find show  - search and show password
        pa find edit  - search and edit password
        pa find del   - search and delete password

    > where are my passwords?

      probably the default location:
        ~/.local/share/pa/passwords

    > how do i rename a password?

      cd ~/.local/share/pa/passwords
      mv foo.age bar.age


  credits
    - This fork is based on pa[7] by biox[8]
    - pa was originally forked from pash[4] by dylanaraps[5]
    - age[1] is a project by Filippo Valsorda[6]
    - age-plugin-se by remko[9] enables Apple Secure Enclave support
    - fzf[10] by junegunn provides fuzzy search functionality


  refs
    [1]: https://age-encryption.org
    [2]: https://j3s.sh/thought/storing-passwords-with-age.html
    [3]: https://github.com/biox/pa/issues/10#issuecomment-1369225383
    [4]: https://github.com/dylanaraps/pash
    [5]: https://github.com/dylanaraps
    [6]: https://filippo.io
    [7]: https://github.com/biox/pa
    [8]: https://github.com/biox
    [9]: https://github.com/remko/age-plugin-se
    [10]: https://github.com/junegunn/fzf
