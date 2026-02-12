#!/bin/bash

# Lista de tamanhos (Obrigatório rodar todos para fazer o gráfico da Q4)
SIZES=("1kB" "2kB" "4kB" "8kB" "16kB")

# Caminhos (Não mexa se estiver na pasta SHA)
SCRIPT_PY="../se_A7.py"
GEM5="/home/vizanca/gem5/build/RISCV/gem5.opt"

# Faz backup
cp $SCRIPT_PY "${SCRIPT_PY}.bak"

# Imprime cabeçalho simples
echo "Size IPC Seconds"

for SIZE in "${SIZES[@]}"; do
    # 1. Muda o tamanho
    sed -i "s/size = \".*kB\"/size = \"$SIZE\"/" $SCRIPT_PY
    
    # 2. Roda (Silenciosamente)
    $GEM5 -d "m5out/A7_$SIZE" $SCRIPT_PY --cmd=./sha_riscv --options="input_large.asc" > /dev/null 2>&1
    
    # 3. Extrai APENAS os números
    if [ -f "m5out/A7_$SIZE/stats.txt" ]; then
        IPC=$(grep "system.cpu.ipc" "m5out/A7_$SIZE/stats.txt" | awk '{print $2}')
        TIME=$(grep "simSeconds" "m5out/A7_$SIZE/stats.txt" | awk '{print $2}')
        echo "$SIZE $IPC $TIME"
    else
        echo "$SIZE ERRO ERRO"
    fi
done

# Restaura
mv "${SCRIPT_PY}.bak" $SCRIPT_PY
