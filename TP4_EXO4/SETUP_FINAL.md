# TP4 EXERCÍCIO 4 - RISC-V com gem5

## 🚀 START RÁPIDO (3 passos)

```bash
# 1. Permissões
chmod +x *.sh

# 2. Verificar configuração
bash test_setup.sh

# 3. Iniciar
bash START_HERE.sh
```

## ✅ Verificação de Pré-Requisitos

Antes de começar, certifique-se que você tem:

- [ ] **gem5** instalado em `/home/vizanca/gem5`
- [ ] **RISC-V GCC**: `sudo apt-get install gcc-riscv64-unknown-elf`
- [ ] **Python3**: `python3 --version`

Verificar com:
```bash
bash test_setup.sh
```

## 📋 O que Fazer

### 1️⃣ Compilação (01_compile_riscv.sh)
Compila Dijkstra e BlowFish para RISC-V usando cross-compiler
```bash
bash 01_compile_riscv.sh
```
**Resultado**: Binários em `binaries/`

### 2️⃣ Simulação (02_run_simulations.sh)
Executa 10 simulações diferentes:
- Cortex A7: L1 = 1KB, 2KB, 4KB, 8KB, 16KB
- Cortex A15: L1 = 2KB, 4KB, 8KB, 16KB, 32KB

Para cada processador e tamanho, simula Dijkstra e BlowFish.

```bash
bash 02_run_simulations.sh
```
**Resultado**: Dados em `results/`

### 3️⃣ Análise (03_analyze_results.py)
Processa arquivos stats.txt e gera gráficos
```bash
python3 03_analyze_results.py results/
```
**Resultado**: CSV e gráficos em `results/analysis_results/`

### 4️⃣ CACTI (Opcional)
Para análise de potência/energia
```bash
cacti -infile cache_L1_A7.cfg -outfile cache_L1_A7.out
```

## 🎯 Saída Esperada

### Estrutura de Resultados
```
results/
├── A7_L1_1KB/dijkstra/stats.txt     ← Métricas de desempenho
├── A7_L1_1KB/blowfish/stats.txt
├── A7_L1_2KB/...
├── A15_L1_2KB/...
└── analysis_results/
    ├── comparison_table.csv         ← Dados tabulares
    ├── performance_comparison.png   ← Gráfico IPC vs L1 Size
    ├── cache_misses_comparison.png  ← Gráfico misses vs config
    └── detailed_metrics.json        ← Dados completos
```

### Métricas Coletadas
| Métrica | Descrição |
|---------|-----------|
| `system.cpu.cpi` | Cycles per instruction |
| `system.cpu.dcache.overall_misses.sum` | D-Cache misses |
| `system.cpu.icache.overall_misses.sum` | I-Cache misses |
| `system.l2.overall_misses.sum` | L2 Cache misses |
| `simSeconds` | Tempo de simulação |

## 📊 Relatório Final

Use o template em `RAPPORT_TEMPLATE.md`:

1. Incluir tabelas de resultados
2. Adicionar gráficos (IPC, cache misses, etc)
3. Análise de conclusões
4. Comparação A7 vs A15
5. Impacto do tamanho de L1

## 🔧 Configuração

### gem5
- **Local**: `/home/vizanca/gem5`
- **Binary**: `/home/vizanca/gem5/build/X86/gem5.opt`
- **ISA**: RISC-V (rv64i)

### RISC-V Compiler
```bash
riscv64-unknown-elf-gcc -O2 -march=rv64i -mabi=lp64
```

### Processadores Simulados
- **Cortex A7**: 4 fetch width, 2 commit width
- **Cortex A15**: 8 fetch width, 4 commit width

## ⚙️ Troubleshooting

**"riscv64-unknown-elf-gcc not found"**
```bash
sudo apt-get install gcc-riscv64-unknown-elf
```

**"gem5 not found"**
- Verificar: `ls /home/vizanca/gem5/build/X86/`
- Se não existir, compilar gem5

**Simulações muito lentas**
- Normal! gem5 é preciso mas lento
- Duração típica: 30min-2h para 10 configs
- Usar `-d` para debug (mais lento ainda)

**Python error ao analisar**
- Verificar arquivo stats.txt existe
- Usar: `python3 03_analyze_results.py -v results/`

## 📚 Documentação Disponível

- **LEIA-ME.txt** - Quick start em português
- **INSTRUCTIONS.md** - Documentação técnica completa
- **RAPPORT_TEMPLATE.md** - Template de relatório
- **ESTRUTURA.txt** - Mapa de diretórios
- **GUIA_VISUAL.txt** - Diagrama de workflow
- **example_results.py** - Exemplos de formato de dados

## 🎓 Próximos Passos

1. `bash test_setup.sh` - Verificar tudo
2. `bash 01_compile_riscv.sh` - Compilar programas
3. `bash 02_run_simulations.sh` - Simular (leva tempo!)
4. `python3 03_analyze_results.py results/` - Analisar
5. Preencher `RAPPORT_TEMPLATE.md` com resultados
6. (Opcional) Executar CACTI para análise de potência

## ❓ FAQ

**P: Quanto tempo leva?**
R: Compilação: 1-2 min, Simulações: 30min-2h, Análise: 1 min

**P: Preciso de CACTI?**
R: Não é obrigatório, mas ajuda na análise de potência

**P: Posso usar ARM em vez de RISC-V?**
R: Sim! gem5 suporta ARM, mas o curso recomenda RISC-V

**P: Como começar se tiver dúvidas?**
R: Execute `bash START_HERE.sh` - menu interativo

## ✨ Dicas

- Comece com: `bash START_HERE.sh`
- Para debug: `bash test_setup.sh`
- Guarde os resultados em backup
- Leia a documentação enquanto simula
- Use example_results.py como referência

---

**Bom trabalho no TP4! 🎯**
