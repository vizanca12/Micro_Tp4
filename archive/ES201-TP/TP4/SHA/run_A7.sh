#!/bin/bash

# --- CONFIGURAÇÃO ---
# Lista de tamanhos para o Cortex A7
SIZES=("1kB" "2kB" "4kB" "8kB" "16kB")

# Caminho para o script Python (confirma se está na pasta anterior)
PYTHON_SCRIPT="../se_A7.py"

# Caminho para o teu GEM5 (baseado nos teus logs anteriores)
GEM5_CMD="/home/vizanca/gem5/build/RISCV/gem5.opt"

# Ficheiro onde vamos guardar os resultados finais
OUTPUT_FILE="resultados_A7.txt"

# --------------------

echo "=== Iniciando Bateria de Testes Cortex A7 ==="
echo "Tamanho | IPC | Tempo(s)" > $OUTPUT_FILE
echo "Tamanho | IPC | Tempo(s)" # Imprime no terminal também

# 1. Faz backup do script original para não estragar nada
cp $PYTHON_SCRIPT "${PYTHON_SCRIPT}.bak"

for SIZE in "${SIZES[@]}"; do
    # Define o nome da pasta de saída para este tamanho
    OUT_DIR="m5out/A7_$SIZE"
    
    # 2. Edita o ficheiro Python automaticamente usando SED
    # Procura qualquer coisa como size = "XXkB" e substitui pelo tamanho atual
    sed -i "s/size = \".*kB\"/size = \"$SIZE\"/" $PYTHON_SCRIPT
    
    # 3. Executa o Gem5 (redireciona a saída chata para /dev/null para limpar o terminal)
    # Se quiseres ver o log completo, remove o " > /dev/null 2>&1"
    echo " -> Simulando com Cache L1 = $SIZE ..."
    $GEM5_CMD -d $OUT_DIR $PYTHON_SCRIPT --cmd=./sha_riscv --options="input_large.asc" > /dev/null 2>&1
    
    # 4. Verifica se o ficheiro stats.txt foi criado
    if [ -f "$OUT_DIR/stats.txt" ]; then
        # Extrai o IPC
        IPC=$(grep "system.cpu.ipc" $OUT_DIR/stats.txt | awk '{print $2}')
        # Extrai o Tempo (simSeconds)
        TIME=$(grep "simSeconds" $OUT_DIR/stats.txt | awk '{print $2}')
        
        # Salva e mostra o resultado
        echo "$SIZE $IPC $TIME" >> $OUTPUT_FILE
        echo "    Resultado: IPC=$IPC, Tempo=$TIME"
    else
        echo "    Erro: stats.txt não encontrado para $SIZE"
    fi
done

# 5. Restaura o script Python original
mv "${PYTHON_SCRIPT}.bak" $PYTHON_SCRIPT

echo "============================================="
echo "Tudo pronto! Os dados estão no ficheiro: $OUTPUT_FILE"
cat $OUTPUT_FILE

