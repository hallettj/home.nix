export extern eza [
  # META OPTIONS
  --help (-?)                # show list of command-line options
  --version (-v)             # show version of eza

  # DISPLAY OPTIONS
  --oneline (-1)             # display one entry per line
  --long (-l)                 # display extended file metadata as a table
  --grid (-G)                # display entries as a grid (default)
  --across (-x)              # sort the grid across, rather than downwards
  --recurse (-R)             # recurse into directories
  --tree (-T)                # recurse into directories as a tree
  --dereference (-X)         # dereference symbolic links when displaying information
  --classify (-F): string    # display type indicator by file names (always, auto, never)
  --color: string            # when to use terminal colours (always, auto, never)
  --color-scale              # highlight levels of 'field' distinctly(all, age, size)
  --color-scale-mode         # use gradient or fixed colors in --color-scale (fixed, gradient)
  --icons: string               # when to display icons (always, auto, never)
  --no-quotes                # don't quote file names with spaces
  --hyperlink                # display entries as hyperlinks
  --absolute                 # display entries with their absolute path (on, follow, off)
  --follow-symlinks          # drill down into symbolic links that point to directories
  --width (-w): int           # set screen width in columns


  # FILTERING AND SORTING OPTIONS
  --all (-a)                 # show hidden and 'dot' files. Use this twice to also show the '.' and '..' directories
  --almost-all (-A)          # equivalent to --all; included for compatibility with `ls -A`
  --list-dirs (-d)           # list directories as files; don't list their contents
  --only-dirs (-D)           # list only directories
  --only-files (-f)          # list only files
  --show-symlinks            # explicitly show symbolic links (for use with --only-dirs | --only-files)
  --no-symlinks              # do not show symbolic links
  --level (-L): int          # limit the depth of recursion
  --reverse (-r)             # reverse the sort order
  --sort (-s): string        # which field to sort by
  --group-directories-first  # list directories before other files
  --group-directories-last   # list directories after other files
  --ignore-glob (-I): string # glob patterns (pipe-separated) of files to ignore
  --git-ignore               # ignore files mentioned in '.gitignore'

  # Valid sort fields:         name, Name, extension, Extension, size, type,
  #                            created, modified, accessed, changed, inode, and none.
  #                            date, time, old, and new all refer to modified.

  # LONG VIEW OPTIONS
  --binary (-b)              # list file sizes with binary prefixes
  --bytes (-B)               # list file sizes in bytes, without any prefixes
  --group (-g)               # list each file's group
  --smart-group              # only show group if it has a different name from owner
  --header (-h)              # add a header row to each column
  --links (-H)               # list each file's number of hard links
  --inode (-i)               # list each file's inode number
  --mounts (-M)              # show mount details (Linux and Mac only)
  --numeric (-n)             # list numeric user and group IDs
  --flags (-O)               # list file flags (Mac, BSD, and Windows only)
  --blocksize (-S)           # show size of allocated file system blocks
  --time (-t): string        # which timestamp field to list (modified, accessed, created)
  --modified (-m)            # use the modified timestamp field
  --accessed (-u)            # use the accessed timestamp field
  --created (-U)             # use the created timestamp field
  --changed                  # use the changed timestamp field
  --time-style: string       # how to format timestamps (default, iso, long-iso, full-iso, relative, or a custom style '+<FORMAT>' like '+%Y-%m-%d %H:%M')
  --total-size               # show the size of a directory as the size of all files and directories inside (unix only)
  --octal-permissions (-o)   # list each file's permission in octal format
  --no-permissions           # suppress the permissions field
  --no-filesize              # suppress the filesize field
  --no-user                  # suppress the user field
  --no-time                  # suppress the time field
  --stdin                    # read file names from stdin, one per line or other separator specified in environment
  --git                      # list each file's Git status, if tracked or ignored
  --no-git                   # suppress Git status (always overrides --git, --git-repos, --git-repos-no-status)
  --git-repos                # list root of git-tree status
  --git-repos-no-status      # list each git-repos branch name (much faster)
    
  --extended (-@)            # list each file's extended attributes and sizes
  --context (-Z)             # list each file's security context
] 
