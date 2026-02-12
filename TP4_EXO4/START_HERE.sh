#!/bin/bash

# ============================================
# TP4 EXERCICE 4 - RISC-V gem5 Simulations
# ============================================
# Este script orientará você através de todo o processo

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "${SCRIPT_DIR}")"

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function print_step() {
    echo -e "\n${GREEN}========================================${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${GREEN}========================================${NC}\n"
}

function print_error() {
    echo -e "${RED}ERRO: $1${NC}"
}

function print_warning() {
    echo -e "${YELLOW}AVISO: $1${NC}"
}

function check_requirement() {
    local cmd=$1
    local name=$2
    
    if command -v ${cmd} &> /dev/null; then
        echo -e "${GREEN}✓${NC} ${name} encontrado: $(which ${cmd})"
        return 0
    else
        echo -e "${RED}✗${NC} ${name} não encontrado"
        return 1
    fi
}

# ==== VERIFICAÇÃO DE PRÉ-REQUISITOS ====
print_step "VERIFICAÇÃO DE PRÉ-REQUISITOS"

all_ok=true

# Verificar RISC-V Compiler
if ! check_requirement "riscv64-unknown-elf-gcc" "RISC-V GCC"; then
    print_warning "Instale com: sudo apt-get install gcc-riscv64-unknown-elf"
    all_ok=false
fi

# Verificar gem5
GEM5_ROOT="/home/vizanca/gem5"
GEM5_BINARY="${GEM5_ROOT}/build/X86/gem5.opt"

if [ -f "${GEM5_BINARY}" ]; then
    echo -e "${GREEN}✓${NC} gem5 encontrado: ${GEM5_BINARY}"
else
    echo -e "${YELLOW}⚠${NC} gem5 não encontrado em ${GEM5_BINARY}"
    print_warning "Verifique a instalação de gem5"
    all_ok=false
fi

# Verificar Python
if ! check_requirement "python3" "Python3"; then
    all_ok=false
fi

echo ""

# ==== MENU PRINCIPAL ====
if [ "$all_ok" = true ]; then
    print_step "MENU PRINCIPAL"
    
    echo "Escolha uma opção:"
    echo ""
    echo "1) Compilar aplicações para RISC-V"
    echo "2) Executar simulações gem5"
    echo "3) Analisar resultados"
    echo "4) Executar tudo (compilar + simular)"
    echo "5) Limpar resultados anteriores"
    echo "6) Ver documentação"
    echo "0) Sair"
    echo ""
    read -p "Escolha (0-6): " choice
    
    case $choice in
        1)
            print_step "COMPILAÇÃO PARA RISC-V"
            bash "${SCRIPT_DIR}/01_compile_riscv.sh"
            ;;
        2)
            print_step "EXECUÇÃO DE SIMULAÇÕES"
            bash "${SCRIPT_DIR}/02_run_simulations.sh"
            ;;
        3)
            print_step "ANÁLISE DE RESULTADOS"
            if [ -d "${SCRIPT_DIR}/results" ]; then
                python3 "${SCRIPT_DIR}/03_analyze_results.py" "${SCRIPT_DIR}/results"
            else
                print_error "Diretório de resultados não encontrado. Execute simulações primeiro."
                exit 1
            fi
            ;;
        4)
            print_step "EXECUÇÃO COMPLETA"
            bash "${SCRIPT_DIR}/01_compile_riscv.sh"
            bash "${SCRIPT_DIR}/02_run_simulations.sh"
            python3 "${SCRIPT_DIR}/03_analyze_results.py" "${SCRIPT_DIR}/results"
            ;;
        5)
            print_step "LIMPEZA DE RESULTADOS"
            if [ -d "${SCRIPT_DIR}/results" ]; then
                read -p "Tem certeza? Esta ação não pode ser desfeita (s/n): " confirm
                if [ "$confirm" = "s" ]; then
                    rm -rf "${SCRIPT_DIR}/results"
                    rm -rf "${SCRIPT_DIR}/binaries"
                    rm -rf "${SCRIPT_DIR}/build"
                    echo "Resultados e binários removidos."
                else
                    echo "Operação cancelada."
                fi
            else
                echo "Não há resultados para limpar."
            fi
            ;;
        6)
            print_step "DOCUMENTAÇÃO"
            if [ -f "${SCRIPT_DIR}/INSTRUCTIONS.md" ]; then
                less "${SCRIPT_DIR}/INSTRUCTIONS.md"
            else
                print_error "Arquivo de documentação não encontrado"
            fi
            ;;
        0)
            echo "Saindo..."
            exit 0
            ;;
        *)
            print_error "Opção inválida"
            exit 1
            ;;
    esac
else
    print_error "Alguns pré-requisitos não foram atendidos!"
    echo ""
    echo "Requisitos necessários:"
    echo "1. RISC-V GCC: sudo apt-get install gcc-riscv64-unknown-elf"
    echo "2. gem5 compilado em: /home/vizanca/gem5"
    echo "3. Python3"
    echo ""
    exit 1
fi

echo ""
echo -e "${GREEN}Processo concluído!${NC}"
