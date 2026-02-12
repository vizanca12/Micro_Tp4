#!/usr/bin/env python3
import os
import stat
import sys

# Path to TP4_EXO4 directory
tp4_path = "/vercel/share/v0-project/TP4_EXO4"

# Check if directory exists
if not os.path.exists(tp4_path):
    print(f"Error: Directory {tp4_path} not found")
    sys.exit(1)

# Make all .sh files executable
scripts_fixed = 0
for filename in os.listdir(tp4_path):
    if filename.endswith(".sh"):
        filepath = os.path.join(tp4_path, filename)
        # Get current permissions
        st = os.stat(filepath)
        # Add execute permissions for owner, group, and others
        os.chmod(filepath, st.st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
        print(f"✓ Made executable: {filename}")
        scripts_fixed += 1

print(f"\nTotal scripts fixed: {scripts_fixed}")
print(f"You can now run: bash {tp4_path}/04_quick_start.sh")
