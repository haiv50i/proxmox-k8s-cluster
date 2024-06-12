#!/bin/bash

# Define the file path
SSH_PATH=".ssh"
SSH_PRIVATE_KEY_FILE=".ssh/ubuntu"

# Ensure the directory exists
if [ ! -d "$SSH_PATH" ]; then
  mkdir -p "$SSH_PATH"
fi

# Check if either PKR_VAR_private_key or TF_VAR_private_key exists
if [ -n "$PKR_VAR_private_key" ] || [ -n "$TF_VAR_private_key" ]; then
  echo "A private key variable exists."
else
  echo "No private key found. Exiting."
  exit 1
fi

# Ensure the ssh key file exists
if [ ! -f "$SSH_PRIVATE_KEY_FILE" ]; then
  touch "$SSH_PRIVATE_KEY_FILE"
fi

# Write the appropriate environment variable to the file
if [ -n "$PKR_VAR_private_key" ]; then
  echo "$PKR_VAR_private_key" > "$SSH_PRIVATE_KEY_FILE"
else
  echo "$TF_VAR_private_key" > "$SSH_PRIVATE_KEY_FILE"
fi

# Ensure proper permissions
chmod 600 "$SSH_PRIVATE_KEY_FILE"
