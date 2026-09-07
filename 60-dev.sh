#!/usr/bin/env bash

AddPackage atool           # A script for managing file archives of various types
AddPackage bat             # Cat clone with syntax highlighting and git integration
AddPackage checkbashisms   # Debian script that checks for bashisms
AddPackage clang           # C language family frontend for LLVM
AddPackage cmake           # A cross-platform open-source make system
AddPackage codespell       # check code for common misspellings
AddPackage diff-so-fancy   # Good-looking diffs with diff-highlight and more
AddPackage docker          # Pack, ship and run any application as a lightweight container
AddPackage gcc             # The GNU Compiler Collection - C and C++ frontends
AddPackage gf-debugger-git # A GDB frontend
AddPackage git-delta       # Syntax-highlighting pager for git and diff output
AddPackage github-cli      # The GitHub CLI
AddPackage go              # Core compiler tools for the Go programming language
AddPackage gum             # A tool for glamorous shell scripts
AddPackage highlight       # Fast and flexible source code highlighter - CLI version
AddPackage meson           # High productivity build system
AddPackage muon-build-git  # meson implementation in C
AddPackage nasm            # 80x86 assembler designed for portability and modularity
AddPackage neovim          # Fork of Vim aiming to improve user experience, plugins, and GUIs
AddPackage npm             # JavaScript package manager
AddPackage parallel        # A shell tool for executing jobs in parallel
AddPackage progress        # Shows running coreutils basic commands and displays stats
AddPackage python-poetry   # Python dependency management and packaging made easy
AddPackage python-pynvim   # Python client for Neovim
AddPackage s3cmd           # A command line client for Amazon S3
AddPackage shellcheck      # Shell script analysis tool
AddPackage qmk             # CLI tool for customizing supported mechanical keyboards.
AddPackage rpi-imager      # Raspberry Pi Imaging Utility
AddPackage rtkit           # Realtime Policy and Watchdog Daemon
AddPackage ruff            # An extremely fast Python linter, written in Rust
AddPackage rust            # Systems programming language focused on safety, speed and concurrency
AddPackage samurai         # ninja-compatible build tool written in C
AddPackage stylua          # Deterministic code formatter for Lua
AddPackage tree-sitter-cli # CLI tool for developing, testing, and using Tree-sitter parsers
AddPackage ty              # Extremely fast Python type checker and language server, written in Rust
AddPackage uv              # An extremely fast Python package installer and resolver written in Rust
AddPackage valgrind        # Tool to help find memory-management problems in programs
AddPackage vulkan-tools    # Vulkan tools and utilities

AddGroup docker '!*' 972
AddUser rtkit '!*' 133 133 '!*' RealtimeKit /proc /usr/bin/nologin '' ''
