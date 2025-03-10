#/usr/bin/env bash

_bun_completions() {
  local LOG_FILE="/tmp/bun_completion.log"
  echo "================ NEW COMPLETION REQUEST ================" >> "$LOG_FILE"
  
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"
  
  echo "COMP_WORDS: ${COMP_WORDS[@]}" >> "$LOG_FILE"
  echo "COMP_CWORD: $COMP_CWORD" >> "$LOG_FILE"
  echo "cur: $cur" >> "$LOG_FILE"
  echo "prev: $prev" >> "$LOG_FILE"
  echo "COMP_LINE: $COMP_LINE" >> "$LOG_FILE"
  
  # Get scripts from package.json
  local script_names=""
  if [[ -f package.json ]]; then
    script_names=$(jq -r '.scripts | keys[]' package.json 2>/dev/null)
    echo "Found scripts: $script_names" >> "$LOG_FILE"
  fi
  
  # Check if we're trying to complete a partial subcommand after a namespace
  if [[ "$COMP_LINE" =~ ([[:alnum:]_-]+):([[:alnum:]_-]*) ]]; then
    local namespace="${BASH_REMATCH[1]}"
    local partial_subcommand="${BASH_REMATCH[2]}"
    echo "Detected namespace:partial pattern, namespace=$namespace, partial=$partial_subcommand" >> "$LOG_FILE"
    
    # Find matching scripts and extract their suffixes
    local matching_suffixes=""
    for script in $script_names; do
      if [[ "$script" == "$namespace:"* ]]; then
        local suffix="${script#$namespace:}"
        # Only include if it starts with the partial subcommand
        if [[ -z "$partial_subcommand" || "$suffix" == "$partial_subcommand"* ]]; then
          matching_suffixes+=" $suffix"
          echo "Found matching suffix: $suffix" >> "$LOG_FILE"
        fi
      fi
    done
    
    echo "All matching suffixes: $matching_suffixes" >> "$LOG_FILE"
    
    if [[ -n "$matching_suffixes" ]]; then
      # If there's just one match and it's exactly the partial subcommand, don't duplicate it
      if [[ "$matching_suffixes" == " $partial_subcommand" ]]; then
        echo "Exact match found, not duplicating" >> "$LOG_FILE"
        return 0
      fi
      
      # Set completions directly without compgen
      COMPREPLY=()
      for suffix in $matching_suffixes; do
        COMPREPLY+=("$suffix")
      done
      echo "Set COMPREPLY directly to: ${COMPREPLY[*]}" >> "$LOG_FILE"
      return 0
    fi
  fi
  
  # Special case for namespace completion with empty suffix
  # If we're completing right after a colon
  if [[ "$cur" == ":" ]] || [[ "$cur" == "" && "$COMP_LINE" == *:* && "$COMP_LINE" != *:*[[:alnum:]]* ]]; then
    echo "Completing for empty suffix after a colon" >> "$LOG_FILE"
    
    # Extract the namespace from COMP_LINE
    local namespace=""
    if [[ "$COMP_LINE" =~ ([[:alnum:]_-]+): ]]; then
      namespace="${BASH_REMATCH[1]}"
      echo "Extracted namespace: $namespace" >> "$LOG_FILE"
      
      # Find scripts that match this namespace and transform them to just the suffix
      local matching_scripts=""
      for script in $script_names; do
        if [[ "$script" == "$namespace:"* ]]; then
          # Extract just the part after namespace:
          local suffix="${script#$namespace:}"
          matching_scripts+=" $suffix"
          echo "Found match: $script, adding suffix: $suffix" >> "$LOG_FILE"
        fi
      done
      
      echo "Matching suffixes: $matching_scripts" >> "$LOG_FILE"
      
      if [[ -n "$matching_scripts" ]]; then
        # Directly set COMPREPLY to avoid any further processing
        COMPREPLY=()
        for match in $matching_scripts; do
          COMPREPLY+=("$match")
        done
        echo "Set COMPREPLY directly to: ${COMPREPLY[*]}" >> "$LOG_FILE"
        return 0
      fi
    fi
  fi
  
  # Regular completion for bun command
  if [[ $COMP_CWORD -eq 1 ]]; then
    local commands="add build completions create dev discord help i init install link pm r remove repl run test unlink update upgrade x"
    
    # Add script names from package.json
    if [[ -n "$script_names" ]]; then
      commands+=" $script_names"
    fi
    
    COMPREPLY=($(compgen -W "$commands" -- "$cur"))
    echo "First level completion: ${COMPREPLY[*]}" >> "$LOG_FILE"
    return 0
  fi
  
  # Handle "bun run" command
  if [[ $COMP_CWORD -eq 2 && "$prev" == "run" ]]; then
    if [[ -n "$script_names" ]]; then
      COMPREPLY=($(compgen -W "$script_names" -- "$cur"))
      echo "bun run completion: ${COMPREPLY[*]}" >> "$LOG_FILE"
    fi
    return 0
  fi
  
  echo "No matches, returning" >> "$LOG_FILE"
  return 0
}

complete -o bashdefault -o default -o nospace -F _bun_completions bun