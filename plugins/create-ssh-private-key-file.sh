#!/bin/bash

# Define the file path
SSH_PATH=".ssh"
SSH_PRIVATE_KEY_FILE=".ssh/ubuntu"

# Ensure the directory exists
if [ ! -d "$SSH_PATH" ]; then
  mkdir -p "$SSH_PATH"
fi

# Ensure the file exists
if [ ! -f "$SSH_PRIVATE_KEY_FILE" ]; then
  touch "$SSH_PRIVATE_KEY_FILE"
fi

# Write the environment variable to the file
echo "$PKR_VAR_private_key" > "$SSH_PRIVATE_KEY_FILE"

# Ensure proper permissions
chmod 600 "$SSH_PRIVATE_KEY_FILE"

