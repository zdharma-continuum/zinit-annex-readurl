#!/usr/bin/env zsh
#
# -*- mode: sh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim:ft=zsh:sw=2:sts=2:et:foldmarker=[[[,]]]:foldmethod=marker
#
# Copyright (c) 2016-2021 Sebastian Gniazdowski and contributors
# Copyright (c) 2021-2022 zdharma-continuum and contributors
#

# According to the Zsh Plugin Standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

autoload -Uz za-readurl-preinit-handler

# FUNCTION: →za-readurl-help-null-handler [[[
# Empty function stub which fills help handler fields
→za-readurl-help-null-handler() {
  :
} # ]]]

# The ice conflict with dl'' from zinit-annex-patch-dl is being handled in the
# other annex
@zi::register-annex \
  "zinit-annex-readurl" \
  hook:preinit-10 \
  za-readurl-preinit-handler \
  →za-readurl-help-null-handler \
  "dlink''|.readurl''"
