---
title: "dyld[1944]: dyld cache '/System/Library/dyld/dyld_shared_cache_x86_64h' not loaded: syscall to map cache into shared region failed"
date: 2022-08-26T17:41:29+08:00
draft: false
mathjax: false
tags:        []
categories:  ["Coding" ]
---

Trying to configure virtualenv on mac, met a similar issue like this one:
[https://stackoverflow.com/questions/70809158/dyld-cache-system-library-dyld-dyld-shared-cache-x86-64h-not-loaded-syscall]

Error messages:
```
$ pip
dyld[1944]: dyld cache '/System/Library/dyld/dyld_shared_cache_x86_64h' not loaded: syscall to map cache into shared region failed
dyld[1944]: Library not loaded: '/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation'
  Referenced from: '/Library/Frameworks/Python.framework/Versions/3.5/Resources/Python.app/Contents/MacOS/Python'
  Reason: tried: '/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation' (no such file), '/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation' (no such file)
Abort trap: 6
```

This is essentially a python issue:
```
$ python3
dyld[1944]: dyld cache '/System/Library/dyld/dyld_shared_cache_x86_64h' not loaded: syscall to map cache into shared region failed
dyld[1944]: Library not loaded: '/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation'
  Referenced from: '/Library/Frameworks/Python.framework/Versions/3.5/Resources/Python.app/Contents/MacOS/Python'
  Reason: tried: '/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation' (no such file), '/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation' (no such file)
Abort trap: 6
```

Solution:
Completely uninstall python, `sudo rm -rf` the conflicting directory (`/Library/Frameworks/Python.framework/`), and install python3 back.
```
$ brew uninstall --ignore-dependencies python3
Uninstalling /usr/local/Cellar/python@3.10/3.10.6_1... (3,113 files, 56.5MB)
```

```
$ sudo rm -rf /Library/Frameworks/Python.framework/  # This is what's causing the issue
$ brew install python3  # Install python3 back
```

And we're good now:
```
$ python3
Python 3.10.6 (main, Aug 11 2022, 13:49:25) [Clang 13.1.6 (clang-1316.0.21.2.5)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> 
[1]+  Stopped                 python3
$
$ pip3

Usage:   
  pip3 <command> [options]

Commands:
  install                     Install packages.
  download                    Download packages.
  uninstall                   Uninstall packages.
  freeze                      Output installed packages in requirements format.
  inspect                     Inspect the python environment.
  list                        List installed packages.
  show                        Show information about installed packages.
  check                       Verify installed packages have compatible dependencies.
  config                      Manage local and global configuration.
  search                      Search PyPI for packages.
  cache                       Inspect and manage pip's wheel cache.
  index                       Inspect information available from package indexes.
  wheel                       Build wheels from your requirements.
  hash                        Compute hashes of package archives.
  completion                  A helper command used for command completion.
  debug                       Show information useful for debugging.
  help                        Show help for commands.
```