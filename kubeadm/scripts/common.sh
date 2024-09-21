retries() {
  local command="$1"
  local error_message="$2"

  for ((i=0; i < 5; i++)); do
    eval "$command"
    if [ $? -eq 0 ]; then
      return 0
    else
      echo "❌ $error_message Attempt $((i + 1)) out of 5. 🔄" | awk '{print toupper($0)}'
      sleep 3
    fi
  done

  exit 1
}
