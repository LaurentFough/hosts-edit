#compdef hosts-edit

__hosts-edit_subcommands() {
  local _commands
  _commands=($(hosts-edit commands --raw))
  local _completions
  _completions=(${_commands[@]})

  for __command in "${_commands[@]}"
  do
    if [[ -n "${__command}" ]]
    then
      _completions+=("${__command}")
    fi
  done

  if [[ "${?}" -eq 0 ]]
  then
    compadd -- "${_completions[@]}"
    return 0
  else
    return 1
  fi
}

__hosts-edit_subcommands "$@"
