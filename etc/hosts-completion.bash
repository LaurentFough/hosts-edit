__hosts-edit_subcommands() {
  local _commands
  _commands=($(hosts-edit commands --raw))
  local _completions
  _completions=(${_commands[@]})

  local _current="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=()


  for __command in "${_commands[@]}"
  do
    if [[ -n "${__command}" ]]
    then
      _completions+=("${__command}")
    fi
  done

  COMPREPLY=($(compgen -W "${_completions[*]}" -- "${_current}"))
}

complete -F __hosts-edit_subcommands hosts-edit
