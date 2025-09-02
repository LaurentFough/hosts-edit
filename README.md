[![Build Status](https://img.shields.io/github/actions/workflow/status/xwmx/hosts/tests.yml?branch=master)](https://github.com/xwmx/hosts/actions)

```
.__                    __                              .___.__  __   
|  |__   ____  _______/  |_  ______           ____   __| _/|__|/  |_ 
|  |  \ /  _ \/  ___/\   __\/  ___/  ______ _/ __ \ / __ | |  \   __\
|   Y  (  <_> )___ \  |  |  \___ \  /_____/ \  ___// /_/ | |  ||  |  
|___|  /\____/____  > |__| /____  >          \___  >____ | |__||__|  
     \/           \/            \/               \/     \/           
```

# hosts-edit

`hosts-edit` is a command line program for managing
[hosts file](https://en.wikipedia.org/wiki/Hosts_\(file\)) entries.

`hosts-edit` works with existing hosts files and entries, making it easier to add,
remove, comment, and search hosts file entries using simple, memorable
commands.

`hosts-edit` is designed to be lightweight, easy to use, and contained in a
single, portable script that can be `curl`ed into any environment.

## Installation

### Homebrew

To install with [Homebrew](http://brew.sh/):

```bash
brew tap LaurentFough/taps
brew install hosts-edit
```

### npm

To install with [npm](https://www.npmjs.com/package/hosts.sh):

```bash
npm install --global hosts.sh
```

### bpkg

To install with [bpkg](https://github.com/bpkg/bpkg):

```bash
bpkg install xwmx/hosts
```

### Make

To install with [Make](https://en.wikipedia.org/wiki/Make_(software)),
clone this repository, navigate to the clone's root directory, and run:

```bash
sudo make install
```

### Manual

To install as an administrator, copy and paste one of the following multi-line
commands:

```bash
# install using wget
sudo wget https://raw.github.com/xwmx/hosts/master/hosts-edit -O /usr/local/bin/hosts-edit &&
  sudo chmod +x /usr/local/bin/hosts-edit &&
  sudo hosts-edit completions install

# install using curl
sudo curl -L https://raw.github.com/xwmx/hosts/master/hosts-edit -o /usr/local/bin/hosts-edit &&
  sudo chmod +x /usr/local/bin/hosts-edit &&
  sudo hosts-edit completions install
```

###### User-only Installation

To install with just user permissions, simply add the `hosts-edit` script to your
`$PATH`. If you already have a `~/bin` directory, for example, you can use
one of the following commands:

```bash
# download with wget
wget https://raw.github.com/LaurentFough/hosts-edit/master/hosts-edit -O ~/bin/hosts-edit && chmod +x ~/bin/hosts-edit

# download with curl
curl -L https://raw.github.com/LaurentFough/hosts-edit/master/hosts-edit -o ~/bin/hosts-edit && chmod +x ~/bin/hosts-edit
```

Installing with just user permissions doesn't install the completions, but
`hosts-edit` works without them. If you have `sudo` access and want to install the
completion scripts, run the following command:

```bash
sudo hosts-edit completions install
```

### Arch Linux

A package for Arch users is also
[available in the AUR](https://aur.archlinux.org/packages/hosts/).

### Tab Completion

Bash and Zsh tab completion is enabled when `hosts` is installed using
Homebrew, npm, bpkg, or Make. If you are installing `hosts` manually,
[completion can be enabled with a few commands](etc/README.md).

## Usage

### Listing Entries

`hosts-edit` with no arguments lists the entries in the system's hosts file:

```bash
> hosts-edit
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
fe80::1%lo0     localhost
```

`hosts-edit` called with a string or regular expression will search for entries
that match.

```bash
> hosts-edit localhost
127.0.0.1   localhost
::1         localhost
fe80::1%lo0 localhost

> hosts-edit '\d\d\d'
127.0.0.1         localhost
255.255.255.255   broadcasthost
```

### Adding Entries

To add an entry, use `hosts-edit add`:

```bash
> hosts-edit add 127.0.0.1 example.com
Added:
127.0.0.1 example.com
```

Run `hosts-edit` or `hosts-edit list` to see the new entry in the list:

```bash
> hosts-edit
127.0.0.1         localhost
255.255.255.255   broadcasthost
::1               localhost
fe80::1%lo0       localhost
127.0.0.1         example.com
```

### Removing Entries

To remove an entry, use `hosts-edit remove`, which can take an IP
address, domain, or regular expression:

```bash
> hosts-edit remove example.com
Removing the following entries:
127.0.0.1	example.com
Are you sure you want to proceed? [y/N] y
Removed:
127.0.0.1	example.com
```

### Blocking and Unblocking Domains

`hosts-edit` provides easy commands for blocking and unblocking domains with IPv4
and IPv6 entries:

```bash
> hosts-edit block example.com
Added:
127.0.0.1   example.com
Added:
fe80::1%lo0 example.com
Added:
::1         example.com

> hosts-edit unblock example.com
Removed:
127.0.0.1   example.com
Removed:
fe80::1%lo0 example.com
Removed:
::1         example.com
```

### Enabling / Disabling Entries

All entries are enabled by default. Disabiling an entry comments it out
so it has no effect, but remains in the hosts file ready to be enabled
again.

```bash
> hosts-edit
127.0.0.1         localhost
255.255.255.255   broadcasthost
::1               localhost
fe80::1%lo0       localhost
127.0.0.1         example.com

> hosts-edit disable example.com
Disabling:
127.0.0.1	example.com

> hosts-edit
127.0.0.1         localhost
255.255.255.255   broadcasthost
::1               localhost
fe80::1%lo0       localhost

Disabled:
---------
127.0.0.1         example.com

> hosts-edit enable example.com
Enabling:
127.0.0.1	example.com

> hosts-edit
127.0.0.1         localhost
255.255.255.255   broadcasthost
::1               localhost
fe80::1%lo0       localhost
127.0.0.1         example.com
```

### Backups

Create backups of your hosts file with `hosts-edit backups create`:

```bash
> hosts-edit backups create
Backed up to /etc/hosts--backup-20200101000000
```

List your backups with `hosts-edit backups`. If you have existing hosts file
backups, `hosts-edit` will include them:

```bash
> hosts-edit backups
hosts--backup-20200101000000
hosts.bak
```

`hosts-edit backups compare` will open your hosts file with `diff`:

```bash
> hosts-edit backups compare hosts--backup-20200101000000
--- /etc/hosts	2020-01-01 00:00:00.000000000
+++ /etc/hosts--backup-20200101000000	2020-01-01 00:00:00.000000000
@@ -8,3 +8,4 @@
 255.255.255.255  broadcasthost
 ::1              localhost
 fe80::1%lo0      localhost
+127.0.0.1        example.com
```

View a backup with `hosts-edit backups show`:

```bash
> hosts-edit backups show hosts--backup-20200101000000
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
fe80::1%lo0     localhost
127.0.0.1       example.com
```

Restore a backup with `hosts-edit backups restore`. Before a backup is
restored, a new one is created to avoid data loss:

```bash
> hosts-edit backups restore hosts--backup-20200101000000
Backed up to /etc/hosts--backup-20200102000001
Restored from backup: hosts--backup-20200101000000
```

### Viewing and Editing `/etc/hosts` Directly

`hosts-edit file` prints the raw contents of `/etc/hosts`:

```bash
> hosts-edit file
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
fe80::1%lo0     localhost
```

`hosts-edit edit` opens `/etc/hosts` in your editor:

```bash
> hosts-edit edit
```

### `--auto-sudo`

When the `--auto-sudo` flag is used, all write operations that require
`sudo` will automatically rerun the command using `sudo` when the current user
does not have write permissions for the hosts file.

To have this option always enabled, add the following line to your shell
configuration (`.bashrc`, `.zshrc`, or similar):

```bash
alias hosts-edit="hosts-edit --auto-sudo"
```

## Help

```text
Usage:
  hosts-edit [<search string>]
  hosts-edit add <ip> <hostname> [<comment>]
  hosts-edit backups [create | (compare | delete | restore | show) <filename>]
  hosts-edit block <hostname>...
  hosts-edit completions (check | install [-d | --download] | uninstall)
  hosts-edit disable (<ip> | <hostname> | <search string>)
  hosts-edit disabled
  hosts-edit edit
  hosts-edit enable (<ip> | <hostname> | <search string>)
  hosts-edit enabled
  hosts-edit file
  hosts-edit list [enabled | disabled | <search string>]
  hosts-edit search <search string>
  hosts-edit show (<ip> | <hostname> | <search string>)
  hosts-edit subcommands [--raw]
  hosts-edit remove (<ip> | <hostname> | <search string>) [--force]
  hosts-edit unblock <hostname>...
  hosts-edit --auto-sudo
  hosts-edit -h | --help
  hosts-edit --version

Options:
  --auto-sudo  Run write commands with `sudo` automatically.
  -h --help    Display this help information.
  --version    Display version information.

Help:
  hosts-edit help [<command>]
```

For full usage, run:

```text
hosts-edit help
```

For help with a particular command, try:

```text
hosts-edit help <command name>
```

## Subcommands

<p align="center">
  <a href="#hosts-edit-1">(default)</a> •
  <a href="#hosts-edit-add">add</a> •
  <a href="#hosts-edit-backups">backups</a> •
  <a href="#hosts-edit-block">block</a> •
  <a href="#hosts-edit-completions">completions</a> •
  <a href="#hosts-edit-disable">disable</a> •
  <a href="#hosts-edit-disabled">disabled</a> •
  <a href="#hosts-edit-edit">edit</a> •
  <a href="#hosts-edit-enable">enable</a> •
  <a href="#hosts-edit-enabled">enabled</a> •
  <a href="#hosts-edit-file">file</a> •
  <a href="#hosts-edit-help">help</a> •
  <a href="#hosts-edit-list">list</a> •
  <a href="#hosts-edit-remove">remove</a> •
  <a href="#hosts-edit-search">search</a> •
  <a href="#hosts-edit-show">show</a> •
  <a href="#hosts-edit-subcommands">subcommands</a> •
  <a href="#hosts-edit-unblock">unblock</a> •
  <a href="#hosts-edit-version">version</a>
</p>

### `hosts-edit`

```text
Usage:
  hosts-edit [<search string>]

Description:
  List the existing IP / hostname pairs, optionally limited to a specified
  state. When provided with a seach string, all matching enabled entries will
  be printed.

  Alias for `hosts-edit list`
```

### `hosts-edit add`

```text
Usage:
  hosts-edit add <ip> <hostname> [<comment>]

Description:
  Add a given IP address and hostname pair, along with an optional comment.

Exit status:
  0   Entry successfully added.
  1   Invalid parameters or entry exists.
```

### `hosts-edit backups`

```text
Usage:
  hosts-edit backups
  hosts-edit backups create
  hosts-edit backups compare <filename>
  hosts-edit backups delete  <filename>
  hosts-edit backups restore <filename> [--skip-backup]
  hosts-edit backups show    <filename>

Subcommands:
  backups           List available backups.
  backups create    Create a new backup of the hosts file.
  backups compare   Compare a backup file with the current hosts file.
  backups delete    Delete the specified backup.
  backups restore   Replace the contents of the hosts file with a
                    specified backup. The hosts file is automatically
                    backed up before being overwritten unless the
                    '--skip-backup' flag is specified.
  backups show      Show the contents of the specified backup file.

Description:
  Manage backups.

Exit status:
  0   Success.
  1   Invalid parameters or backup not found.
```

### `hosts-edit block`

```text
Usage:
  hosts-edit block <hostname>...

Description:
  Block one or more hostnames by adding new entries assigned to `127.0.0.1`
  for IPv4 and both `fe80::1%lo0` and `::1` for IPv6.

Exit status:
  0   <hostname> successfully blocked.
  1   Invalid parameters or entry exists.
```

#### Blocklists

- [jmdugan/blocklists](https://github.com/jmdugan/blocklists)
- [notracking/hosts-blocklists](https://github.com/notracking/hosts-blocklists)

### `hosts-edit completions`

```text
Usage:
  hosts-edit completions (check | install [-d | --download] | uninstall)

Options:
  -d, --download  Download the completion scripts and install.

Description:
  Manage completion scripts. For more information, visit:
  https://github.com/xwmx/hosts/blob/master/etc/README.md

Exit status:
  0   Completions successfully installed.
  1   Invalid parameters or other error.
```

### `hosts-edit disable`

```text
Usage:
  hosts-edit disable (<ip> | <hostname> | <search string>)

Description:
  Disable one or more entries based on a given ip address, hostname, or
  search string.

Exit status:
  0   Entry successfully disabled.
  1   Invalid parameters or entry not found.
```

### `hosts-edit disabled`

```text
Usage:
  hosts-edit disabled

Description:
  List all disabled entries. This is an alias for `hosts-edit list disabled`.

Exit status:
  0   One or more disabled entries found.
  1   Invalid parameters or no disabled entries found.
```

### `hosts-edit edit`

```text
Usage:
  hosts-edit edit

Description:
  Open the /etc/hosts file in your $EDITOR.
```

### `hosts-edit enable`

```text
Usage:
  hosts-edit enable (<ip> | <hostname> | <search string>)

Description:
  Enable one or more disabled entries based on a given ip address, hostname,
  or search string.

Exit status:
  0   Entry successfully enabled.
  1   Invalid parameters or entry not found.
```

### `hosts-edit enabled`

```text
Usage:
  hosts-edit enabled

Description:
  List all enabled entries. This is an alias for `hosts-edit list enabled`.

Exit status:
  0   One or more enabled entries found.
  1   Invalid parameters or no enabled entries found.
```

### `hosts-edit file`

```text
Usage:
  hosts-edit file

Description:
  Print the entire contents of the /etc/hosts file.
```

### `hosts-edit help`

```text
Usage:
  hosts-edit help [<command>]

Description:
  Display help information for hosts or a specified command.
```

### `hosts-edit list`

```text
Usage:
  hosts-edit list [enabled | disabled | <search string>]

Description:
  List the existing IP / hostname pairs, optionally limited to a specified
  state. When provided with a seach string, all matching enabled entries will
  be printed.

Exit status:
  0   One or more matching entries found.
  1   Invalid parameters or entry not found.
```

### `hosts-edit remove`

```text
Usage:
  hosts-edit remove (<ip> | <hostname> | <search string>) [--force]
  hosts-edit remove <ip> <hostname>

Options:
  --force  Skip the confirmation prompt.

Description:
  Remove one or more entries based on a given IP address, hostname, or search
  string. If an IP and hostname are both provided, only entries matching the
  IP and hostname pair will be removed.

Exit status:
  0   Entry successfully removed.
  1   Invalid parameters or entry not found.
```

### `hosts-edit search`

```text
Usage:
  hosts-edit search <search string>

Description:
  Search entries for <search string>.

Exit status:
  0   One or more matching entries found.
  1   Invalid parameters or entry not found.
```

### `hosts-edit show`

```text
Usage:
  hosts-edit show (<ip> | <hostname> | <search string>)

Description:
  Print entries matching a given IP address, hostname, or search string.

Exit status:
  0   One or more matching entries found.
  1   Invalid parameters or entry not found.
```

### `hosts-edit subcommands`

```text
Usage:
  hosts-edit subcommands [--raw]

Options:
  --raw  Display the subcommands list without formatting.

Description:
  Display the list of available subcommands.
```

### `hosts-edit unblock`

```text
Usage:
  hosts-edit unblock <hostname>...

Description:
  Unblock one or more hostnames by removing the entries from the hosts file.

Exit status:
  0   <hostname> successfully unblocked.
  1   Invalid parameters or entry not found
```

### `hosts-edit version`

```text
Usage:
  hosts-edit (version | --version)

Description:
  Display the current program version.
```

## Tests

To run the [test suite](test), install [Bats](https://github.com/sstephenson/bats) and
run `bats test` in the project root directory.

---
<p align="center">
  Copyright (c) 2015-present William Melody • See LICENSE for details.
</p>

<p align="center">
  <a href="https://github.com/xwmx/hosts">github.com/xwmx/hosts</a>
</p>
