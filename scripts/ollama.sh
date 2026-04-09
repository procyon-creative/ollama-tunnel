# Source this file in your .zshrc or .bashrc:
#   source /path/to/ollama-tunnel/scripts/ollama.sh

OLLAMA_TUNNEL_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)"

ollama() {
  "$OLLAMA_TUNNEL_SCRIPT_DIR/ollama-run.sh" "$@"
}

# Bash completion
if [ -n "$BASH_VERSION" ]; then
  _ollama_completions() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local cmds="serve create show run push pull cp rm list ps stop help"
    COMPREPLY=($(compgen -W "$cmds" -- "$cur"))
  }
  complete -o default -F _ollama_completions ollama
fi

# Zsh completion
if [ -n "$ZSH_VERSION" ]; then
  _ollama_completions() {
    local cmds=(serve create show run push pull cp rm list ps stop help)
    compadd -- $cmds
  }
  compdef _ollama_completions ollama
fi
