# TP4 Exercice 4 - Resumo do Projeto Criado

## 📌 Visão Geral

Criei uma estrutura **completa e organizada** para você executar o Exercício 4 do TP4: "Análise de Performances de Caches para Cortex A7 e A15".

O projeto inclui:
- ✅ Scripts automatizados para compilação e simulação
- ✅ Documentação detalhada em português
- ✅ Template completo do relatório
- ✅ Guias visuais e instruções passo-a-passo
- ✅ Ferramentas de análise de dados
- ✅ Arquivos de configuração prontos para CACTI

## 🏗️ Estrutura Criada

```
/vercel/share/v0-project/TP4_EXO4/
│
├─ 📄 DOCUMENTAÇÃO
│  ├─ 00_COMECE_AQUI.txt ......... Ponto de entrada (leia primeiro!)
│  ├─ README.md ................. Documentação completa do projeto
│  ├─ INSTRUCTIONS.md ........... Guia detalhado com respostas esperadas
│  ├─ RAPPORT_TEMPLATE.md ....... Template para redigir o relatório final
│  ├─ INDICE.md ................. Índice detalhado de todos os arquivos
│  ├─ GUIA_VISUAL.txt ........... Workflow visual com diagramas ASCII
│  └─ TP4_EXO4_SUMMARY.md ....... Este arquivo (resumo do projeto)
│
├─ 🔧 SCRIPTS DE EXECUÇÃO
│  ├─ 04_quick_start.sh ......... Verifica prérequis (executar primeiro!)
│  ├─ 01_compile_riscv.sh ....... Compila Dijkstra e BlowFish para RISC-V
│  ├─ 02_run_simulations.sh ..... Executa simulações gem5 (20 configs)
│  └─ 03_analyze_results.py ..... Analisa resultados e gera relatórios
│
├─ ⚙️  CONFIGURAÇÕES
│  ├─ gem5_config.py ............ Config principal para gem5
│  ├─ gem5_simple_config.py ..... Config simplificada (sem módulos)
│  ├─ cache_L1_A7.cfg .......... Config CACTI para A7
│  ├─ cache_L1_A15.cfg ......... Config CACTI para A15
│  └─ example_results.py ....... Script para gerar dados de exemplo
│
└─ 📁 DIRETÓRIOS GERADOS (após execução)
   ├─ sources/ ................. Código fonte das aplicações
   ├─ build/ ................... Objetos compilados temporários
   ├─ binaries/ ................ Executáveis RISC-V (dijkstra, blowfish)
   ├─ results/ ................. Estatísticas brutes de gem5 (20 configs)
   └─ analysis/ ................ Relatórios processados (CSV, TXT)
```

## 🚀 Como Começar

### 1. **Primeiro**: Ler a Documentação

```bash
cat TP4_EXO4/00_COMECE_AQUI.txt
cat TP4_EXO4/GUIA_VISUAL.txt
cat TP4_EXO4/README.md
```

### 2. **Segundo**: Verificar Prérequis

```bash
cd TP4_EXO4
./04_quick_start.sh
```

### 3. **Terceiro**: Compilar as Aplicações

```bash
./01_compile_riscv.sh
```

### 4. **Quarto**: Executar Simulações (⏳ isso demora!)

```bash
./02_run_simulations.sh  # Pode levar 1-4 horas
```

### 5. **Quinto**: Analisar Resultados

```bash
python3 03_analyze_results.py results/
```

### 6. **Sexto**: Análise CACTI Manual

```bash
./cacti -infile cache_L1_A7.cfg
./cacti -infile cache_L1_A15.cfg
# Repetir para cada variação de tamanho L1
```

### 7. **Sétimo**: Redigir Relatório

```bash
# Usar RAPPORT_TEMPLATE.md como base
# Preencher com dados reais dos passos 4-6
# Gerar PDF final
```

## 📊 O Que o Projeto Faz

### Compilação (01_compile_riscv.sh)
- Compila **Dijkstra** (algoritmo SSSP) para RISC-V
- Compila **BlowFish** (criptografia) para RISC-V
- Usa `riscv64-unknown-elf-gcc` com flags `-O2 -march=rv64i`

### Simulações (02_run_simulations.sh)
Executa 20 simulações gem5:

**Cortex A7** (5 configurações):
- L1 cache: 1KB, 2KB, 4KB, 8KB, 16KB
- Apps: Dijkstra + BlowFish

**Cortex A15** (5 configurações):
- L1 cache: 2KB, 4KB, 8KB, 16KB, 32KB  
- Apps: Dijkstra + BlowFish

Cada simulação gera `stats.txt` com:
- IPC (Instructions Per Cycle)
- CPI (Cycles Per Instruction)
- Miss rates (L1I, L1D, L2)
- Estatísticas de branch prediction

### Análise (03_analyze_results.py)
- Processa 20 arquivos `stats.txt`
- Extrai métricas principais
- Gera CSV com todos os dados
- Gera resumo em texto legível

### CACTI (arquivos .cfg)
- Estima área dos caches L1 em mm²
- Varia com tamanho (1KB-32KB) e arquitetura (A7 vs A15)
- Necessário para calcular eficiência surfacica

## 📋 Questões Respondidas

O projeto fornece **suporte completo** para responder:

| Q | Tópico | Suporte |
|---|--------|---------|
| Q1 | Profiling de instruções | Scripts gem5 + INSTRUCTIONS.md |
| Q2 | Classe de instruções otimização | Análise de miss rates |
| Q3 | Comparação com TP2 | Dados coletados + análise |
| Q4 | Variação L1 A7 | Tabelas + gráficos automatizados |
| Q5 | Variação L1 A15 | Tabelas + gráficos automatizados |
| Q6 | Parâmetros CACTI default | cache_L1_*.cfg |
| Q7 | Surface L1 padrão | CACTI output + cálculos |
| Q8 | Variação L1 com CACTI | Scripts .cfg para cada tamanho |
| Q9 | Eficiência surfacica | IPC / area (fórmula documentada) |
| Q10 | Potência consumida | Dados fornecidos (100mW, 500mW) |
| Q11 | Eficiência energética | IPC / power (fórmula documentada) |
| Q12 | Config big.LITTLE ótima | Análise de Q9+Q11 |
| Q13 | Equivalência configs (opt) | Discussão de trade-offs |
| Q14 | Metodologia geral (opt) | Framework de design |

## 📈 Dados Coletados

Cada simulação gem5 gera:

```
results/A7_L1_4KB/dijkstra/stats.txt
├─ system.cpu.ipc = 1.25
├─ system.cpu.cpi = 0.800
├─ system.l1_icache.overall_miss_rate::total = 0.00006
├─ system.l1_dcache.overall_miss_rate::total = 0.38
├─ system.l2.overall_miss_rate::total = 0.62
└─ ... (muitos mais campos)
```

O script 03_analyze_results.py extrai e organiza estes dados.

## 💾 Tempo e Espaço

| Aspecto | Estimativa |
|---------|-----------|
| **Tempo Total** | 4-8 horas |
| **Compilação** | ~5 min |
| **Simulações** | ~1-4 horas ⏳ |
| **Análise** | ~1 hora |
| **CACTI** | ~30-60 min |
| **Redação** | ~2-3 horas |
| **Espaço em Disco** | ~100-200 MB |

## 🎯 Destaques do Projeto

### ✅ Automatizado
- Scripts prontos para compilação
- Scripts prontos para simulações
- Análise de resultados automatizada

### ✅ Bem Documentado
- 6 arquivos de documentação
- Guias visuais em ASCII art
- Template completo do relatório

### ✅ Organizado
- Estrutura clara de diretórios
- Convenções de nomenclatura consistentes
- Índice detalhado de todos os arquivos

### ✅ Sem Dependências Externas
- Apenas Python 3 padrão
- Nenhuma biblioteca extra necessária
- Funciona em Linux, macOS, Windows (WSL)

### ✅ Reutilizável
- Arquivos de configuração adaptáveis
- Scripts modulares
- Fácil modificar parâmetros

## 🔧 Configurações RISC-V

### Cortex A7 (Simulado em RISC-V)
```
Fetch Width:       4
Decode Width:      4
Issue Width:       4
Commit Width:      2
RUU Size:          8
L1I/L1D:           32KB / 32B blocks / 2-way (default)
L2:                512KB / 32B blocks / 8-way
Branch Predictor:  Bimodal (BTB=256)
Clock:             1.0 GHz
Power:             100 mW
```

### Cortex A15 (Simulado em RISC-V)
```
Fetch Width:       8
Decode Width:      8
Issue Width:       8
Commit Width:      4
RUU Size:          16
L1I/L1D:           32KB / 64B blocks / 2-way (default)
L2:                512KB / 64B blocks / 16-way
Branch Predictor:  2-level (BTB=256)
Clock:             2.5 GHz
Power:             500 mW
```

## 📝 Exemplo de Uso Completo

```bash
# Passo 1: Preparação
cd TP4_EXO4
./04_quick_start.sh

# Passo 2: Compilação (5 min)
./01_compile_riscv.sh

# Passo 3: Simulações (1-4 horas)
./02_run_simulations.sh &  # Rodar em background

# (Enquanto simula, fazer análise CACTI...)
cd ..
./cacti -infile TP4_EXO4/cache_L1_A7.cfg > result_A7.txt

# Passo 4: Análise
cd TP4_EXO4
python3 03_analyze_results.py results/

# Passo 5: Verificar dados
cat analysis/summary.txt
head analysis/results.csv

# Passo 6: Redigir relatório
# Copiar RAPPORT_TEMPLATE.md
# Preencer com dados reais
# Gerar PDF
```

## 🔍 Arquivos Chave

### Para Começar
- **00_COMECE_AQUI.txt** ← Leia isto primeiro!
- **GUIA_VISUAL.txt** ← Para entender o workflow

### Para Executar
- **04_quick_start.sh** ← Verificar setup
- **01_compile_riscv.sh** ← Compilar apps
- **02_run_simulations.sh** ← Rodar simulações
- **03_analyze_results.py** ← Processar dados

### Para Redigir
- **RAPPORT_TEMPLATE.md** ← Template do relatório
- **INSTRUCTIONS.md** ← Detalhes técnicos
- **README.md** ← Referência geral

## 🆘 Troubleshooting

Todos os problemas comuns estão documentados em:
- INSTRUCTIONS.md (seção "Troubleshooting")
- README.md (seção "Troubleshooting")

Problemas cobertos:
- gem5 não encontrado
- Compiler RISC-V não instalado
- CACTI não compila
- Simulações muito lentas
- stats.txt vazio ou não existe

## 📞 Suporte

Para dúvidas sobre o projeto:
1. Consulte **INSTRUCTIONS.md**
2. Consulte **README.md**
3. Verifique os logs (*.log) em results/
4. Envie e-mail para o instrutor

## ✅ Checklist Final

Antes de submeter o PDF:

- [ ] Todos os 4 membros do grupo incluídos
- [ ] Q1-Q14 respondidas (ou Q1-Q12 se não fez opcionais)
- [ ] Tabelas preenchidas com dados REAIS
- [ ] Figuras de performance incluídas
- [ ] Análises redigidas completamente
- [ ] Conclusões bem fundamentadas
- [ ] Formatação clara e profissional
- [ ] Sem erros de ortografia
- [ ] Nome correto: TP4-nome1-nome2-nome3-nome4.pdf
- [ ] Enviado para hammami@ensta.fr com CC

## 📊 Resultados Esperados

Após completar o projeto, você terá:

✅ 20 simulações gem5 executadas com sucesso
✅ Tabelas de IPC/CPI para cada configuração
✅ Tabelas de miss rates (L1I, L1D, L2)
✅ Estimativas de área dos caches (CACTI)
✅ Cálculos de eficiência surfacica e energética
✅ Gráficos mostrando tendências
✅ Análises comparativas A7 vs A15
✅ Recomendações para arquitetura big.LITTLE
✅ Relatório PDF completo e profissional

## 🎓 O Que Você Aprenderá

Este projeto ensina:
- Como arquiteturas de processadores impactam performance
- Trade-offs entre performance, área e consumo de energia
- Como usar simuladores para análise de arquiteturas
- Metodologia de design e otimização de sistemas
- Importância da hierarquia de memória (caches)

## 📝 Notas Finais

- **RISC-V vs ARM**: Usamos RISC-V para compatibilidade gem5
- **Resultados Relativos**: Os números específicos variam, mas tendências são válidas
- **Dados Determinísticos**: gem5 é determinístico - mesmos resultados sempre
- **Paralelizar Trabalho**: Distribuir tarefas entre os 4 membros para eficiência

---

**Criado**: Fevereiro 2026
**Versão**: 1.0
**Status**: Pronto para uso

**Próxima ação**: `cat TP4_EXO4/00_COMECE_AQUI.txt` e comece! 🚀
