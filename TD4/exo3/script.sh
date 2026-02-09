#!/usr/bin/env bash
set -euo pipefail

# --------- A ADAPTER ----------
GEM5="../../../build/ARM/gem5.opt"   
CFG="./se.py"                      
BIN_DIR="."                        
# --------------------------------

PROGS=("normale" "pointer" "tempo" "unrol")
CONFS=("C1" "C2")

OUTFILE="results_matrix_cache.txt"

extract_miss () {
  local stats="$1"
  local pat="$2"
  grep -m1 -E "$pat" "$stats" | awk '{print $2}'
}

run_one () {
  local prog="$1"
  local conf="$2"
  local outdir="$3"
  local bin="${BIN_DIR}/${prog}_armv7"

  mkdir -p "$outdir"

  "$GEM5" -d "$outdir" "$CFG" --cmd="$bin" --config="$conf" >/dev/null

  local stats="$outdir/stats.txt"
  local imiss dmiss l2miss

  imiss=$(extract_miss "$stats" "system\.cpu\.icache\.overallMissRate::total" || true)
  dmiss=$(extract_miss "$stats" "system\.cpu\.dcache\.overallMissRate::total" || true)
  l2miss=$(extract_miss "$stats" "system\.l2cache\.overallMissRate::total" || true)

  printf "%-10s %-4s %-12s %-12s %-12s\n" \
    "$prog" "$conf" "${imiss:-NA}" "${dmiss:-NA}" "${l2miss:-NA}" >> "$OUTFILE"
}

echo "PROG       CONF IL1_miss     DL1_miss     L2_miss" > "$OUTFILE"

for p in "${PROGS[@]}"; do
  for c in "${CONFS[@]}"; do
    out="m5out_${p}_${c}"
    echo "==> RUN $p / $c -> $out"
    run_one "$p" "$c" "$out"
  done
done

echo "Wrote $OUTFILE"
