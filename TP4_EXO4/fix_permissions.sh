#!/bin/bash

# Fix permissions for all shell scripts in this directory
echo "Fixing permissions for TP4_EXO4 scripts..."

chmod +x /vercel/share/v0-project/TP4_EXO4/01_compile_riscv.sh
chmod +x /vercel/share/v0-project/TP4_EXO4/02_run_simulations.sh
chmod +x /vercel/share/v0-project/TP4_EXO4/04_quick_start.sh

echo "Done! Permissions fixed."
echo ""
echo "You can now run:"
echo "  bash /vercel/share/v0-project/TP4_EXO4/04_quick_start.sh"
