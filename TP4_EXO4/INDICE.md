# Indice des Fichiers - TP4 Exercice 4

## 📑 Documentação

### `README.md` (Obrigatório)
- **Conteúdo**: Visão geral do projeto, instruções de instalação, estrutura, workflow, FAQ
- **Para quem**: Todos os membros do grupo
- **Ler primeiro**: ✓ SIM
- **Tamanho**: ~15 min de leitura

### `INSTRUCTIONS.md` (Obrigatório)
- **Conteúdo**: Documentação detalhada de cada etapa, respostas às questões, arquitecturas
- **Para quem**: Todos (especialmente durante execução)
- **Referência técnica**: ✓ SIM
- **Tamanho**: ~20 min de leitura

### `RAPPORT_TEMPLATE.md` (Obrigatório)
- **Conteúdo**: Template completo do relatório com todas as questões
- **Para quem**: Redação do relatório
- **Usar para**: Redigir o PDF final
- **Tamanho**: ~40-60 min de preenchimento

### `INDICE.md` (Este arquivo)
- **Conteúdo**: Índice detalhado de todos os arquivos do projeto
- **Para quem**: Navegação e organização
- **Referência rápida**: ✓ SIM

## 🔧 Scripts de Execução

### `04_quick_start.sh` (Começar aqui)
- **Objetivo**: Verificar prérequis e guiar através dos passos iniciais
- **Executar**: `./04_quick_start.sh`
- **Cria**: Script de configuração gem5 simplificado
- **Tempo**: ~5 min
- **Resultado**: Confirmação que tudo está pronto

### `01_compile_riscv.sh` (Segundo passo)
- **Objetivo**: Compilar Dijkstra e BlowFish para RISC-V
- **Executar**: `./01_compile_riscv.sh`
- **Entrada**: Código fonte das aplicações
- **Saída**: `binaries/dijkstra`, `binaries/blowfish`
- **Tempo**: ~2-5 min
- **Requer**: RISC-V toolchain (gcc-riscv64-unknown-elf)

### `02_run_simulations.sh` (Terceiro passo)
- **Objetivo**: Executar simulações gem5 com todas as configurações
- **Executar**: `./02_run_simulations.sh`
- **Entrada**: Binários RISC-V compilados
- **Saída**: `results/A[7|15]_L1_*KB/[dijkstra|blowfish]/stats.txt`
- **Tempo**: ~1-4 horas (dependendo da máquina)
- **Requer**: gem5 com suporte RISC-V
- **Configurações**: 
  - A7: 5 tamanhos L1 × 2 apps = 10 simulações
  - A15: 5 tamanhos L1 × 2 apps = 10 simulações
  - Total: 20 simulações

### `03_analyze_results.py` (Quarto passo)
- **Objetivo**: Analisar resultados gem5 e gerar relatórios
- **Executar**: `python3 03_analyze_results.py results/`
- **Entrada**: Arquivos `stats.txt` de gem5
- **Saída**: 
  - `analysis/results.csv` (tabela completa)
  - `analysis/summary.txt` (resumo legível)
- **Tempo**: ~5 min
- **Requer**: Python 3.6+

## 🔬 Scripts de Configuração

### `gem5_config.py` (Principal)
- **Objetivo**: Configuração gem5 completa (usando modules)
- **Uso**: `gem5 -c gem5_config.py --processor=a7 ...`
- **Paramêtros suportados**:
  - `--processor`: a7 ou a15
  - `--l1i_size`: tamanho L1 instruções
  - `--l1d_size`: tamanho L1 dados
  - `--l2_size`: tamanho L2
  - `--binary`: caminho do binário
- **Nota**: Requer instalação padrão de gem5

### `gem5_simple_config.py` (Simplificado)
- **Objetivo**: Configuração simplificada sem dependências internas
- **Uso**: Referência e exemplo de código
- **Contém**: Classes de configuração A7 e A15 predefinidas
- **Útil**: Se gem5 não tiver módulos padrão instalados

## 📊 Configuração CACTI

### `cache_L1_A7.cfg`
- **Objetivo**: Configuração CACTI para A7 L1 padrão
- **Especificações**: 32KB, 32B blocks, 2-way associative
- **Uso**: `./cacti -infile cache_L1_A7.cfg`
- **Saída**: Estimativas de área em mm²
- **Nota**: Adaptar para cada variação de tamanho

### `cache_L1_A15.cfg`
- **Objetivo**: Configuração CACTI para A15 L1 padrão
- **Especificações**: 32KB, 64B blocks, 2-way associative
- **Uso**: `./cacti -infile cache_L1_A15.cfg`
- **Saída**: Estimativas de área em mm²
- **Nota**: Bloco maior que A7 devido à arquitetura

## 🎯 Scripts de Análise e Exemplos

### `example_results.py` (Referência)
- **Objetivo**: Gerar dados de exemplo como referência
- **Executar**: `python3 example_results.py`
- **Gera**:
  - `example_results.csv` (tabela exemplo)
  - `example_summary.txt` (resumo exemplo)
  - `example_efficiency.csv` (eficiências exemplo)
- **Uso**: Verificar formato e estrutura de dados esperados
- **Tempo**: ~2 min
- **Importante**: Estes são DADOS DE EXEMPLO, não reais!

## 📁 Diretórios Gerados

### `sources/`
- **Conteúdo**: Código fonte das aplicações (copiado de archive/)
- **Contém**: dijkstra.c, blowfish.c, arquivos .h
- **Criado por**: `01_compile_riscv.sh`

### `build/`
- **Conteúdo**: Arquivos compilados temporários
- **Contém**: Objetos .o, arquivos intermediários
- **Criado por**: `01_compile_riscv.sh`
- **Pode ser deletado**: Após compilação completa

### `binaries/`
- **Conteúdo**: Executáveis RISC-V finais
- **Contém**: dijkstra, blowfish
- **Criado por**: `01_compile_riscv.sh`
- **Importante**: Não deletar - necessário para simulações

### `results/`
- **Conteúdo**: Resultados brutos das simulações gem5
- **Estrutura**:
  ```
  results/
  ├── A7_L1_1KB/
  │   ├── dijkstra/
  │   │   └── stats.txt
  │   └── blowfish/
  │       └── stats.txt
  ├── A7_L1_2KB/
  │   ├── dijkstra/
  │   │   └── stats.txt
  │   └── blowfish/
  │       └── stats.txt
  ... (e assim por diante)
  ```
- **Criado por**: `02_run_simulations.sh`
- **Importante**: Arquivos de referência - backup antes de deletar

### `analysis/`
- **Conteúdo**: Relatórios e análises processadas
- **Contém**:
  - `results.csv` (tabela completa)
  - `summary.txt` (resumo legível)
- **Criado por**: `03_analyze_results.py`
- **Tamanho**: ~100-200 KB

## 📋 Checklist de Execução

### Fase 1: Preparação (Tempo: ~15 min)
- [ ] Ler `README.md`
- [ ] Ler `INSTRUCTIONS.md`
- [ ] Executar `./04_quick_start.sh`
- [ ] Verificar prérequis (gem5, RISC-V compiler, CACTI)

### Fase 2: Compilação (Tempo: ~5 min)
- [ ] Executar `./01_compile_riscv.sh`
- [ ] Verificar `binaries/dijkstra` existe
- [ ] Verificar `binaries/blowfish` existe

### Fase 3: Simulações (Tempo: ~1-4 horas)
- [ ] Executar `./02_run_simulations.sh`
- [ ] Aguardar conclusão (podem ser 20 simulações)
- [ ] Verificar `results/A7_L1_1KB/dijkstra/stats.txt` existe
- [ ] Verificar `results/A15_L1_32KB/blowfish/stats.txt` existe

### Fase 4: Análise gem5 (Tempo: ~5 min)
- [ ] Executar `python3 03_analyze_results.py results/`
- [ ] Verificar `analysis/results.csv` gerado
- [ ] Verificar `analysis/summary.txt` gerado
- [ ] Revisar dados coletados

### Fase 5: Análise CACTI (Tempo: ~30-60 min)
- [ ] Para cada configuração L1, criar `.cfg`
- [ ] Executar `./cacti -infile cache_*.cfg`
- [ ] Extrair áreas estimadas em mm²
- [ ] Preencher tabela Q7 e Q8

### Fase 6: Cálculos Finais (Tempo: ~30-60 min)
- [ ] Calcular eficiência surfacica (IPC/area)
- [ ] Calcular eficiência energética (IPC/power)
- [ ] Preencer tabelas Q9 e Q11
- [ ] Gerar gráficos de performance

### Fase 7: Redação do Relatório (Tempo: ~2-3 horas)
- [ ] Usar `RAPPORT_TEMPLATE.md` como base
- [ ] Preencher todas as questões Q1-Q14
- [ ] Incluir tabelas e figuras
- [ ] Redigir análises e conclusões
- [ ] Verificar formatação e clareza

### Fase 8: Submissão (Tempo: ~10 min)
- [ ] Converter para PDF: `TP4-nom1-nom2-nom3-nom4.pdf`
- [ ] Incluir código e análises
- [ ] Enviar para: `hammami@ensta.fr`
- [ ] CC: Seu chargé de TD
- [ ] Subject: `ECE_4ES01_TA/TP4`
- [ ] Deadline: 23/02/2026

## 🔍 Ordem de Leitura Recomendada

1. **Para começar rapidamente**: README.md → 04_quick_start.sh
2. **Para entender o projeto**: INSTRUCTIONS.md → RAPPORT_TEMPLATE.md
3. **Para referência técnica**: gem5_config.py, cache_L1_*.cfg
4. **Para verificar formato**: example_results.py
5. **Para submissão final**: RAPPORT_TEMPLATE.md

## 💾 Espaço de Disco Estimado

| Diretório | Tamanho |
|---|---|
| sources/ | ~500 KB |
| build/ | ~1-2 MB |
| binaries/ | ~500 KB |
| results/ | ~100-200 MB (20 simulações) |
| analysis/ | ~200-500 KB |
| **Total estimado** | **~100-200 MB** |

## ⏱️ Tempo Total Estimado

| Fase | Tempo |
|---|---|
| Preparação | 15 min |
| Compilação | 5 min |
| Simulações | 1-4 horas |
| Análise | 1 hora |
| CACTI | 30-60 min |
| Cálculos | 30-60 min |
| Redação | 2-3 horas |
| **TOTAL** | **4-8 horas** |

*Nota: Tempo varia bastante conforme poder computacional da máquina*

## 🆘 Troubleshooting Rápido

### gem5 não encontrado
```bash
which gem5
# Se não encontrar, adicionar PATH ou usar caminho completo
export PATH=/path/to/gem5:$PATH
```

### RISC-V compiler não encontrado
```bash
riscv64-unknown-elf-gcc --version
# Se não encontrar: sudo apt-get install gcc-riscv64-unknown-elf
```

### stats.txt vazio ou não existe
```bash
# Verificar logs
cat results/A7_L1_4KB/dijkstra.log
# gem5 pode ter falhado - verificar erro
```

### Python 3 não disponível
```bash
python3 --version
# Se não encontrar: sudo apt-get install python3
```

### Espaço em disco insuficiente
```bash
# Apagar build/ (já não é necessário após compilação)
rm -rf build/
# Arquivar results/ se necessário
tar -czf results.tar.gz results/
```

## 📞 Contactos

- **Instrutor**: hammami@ensta.fr
- **Chargé de TD**: [Adicionar e-mail]
- **Assunto**: ECE_4ES01_TA/TP4
- **Deadline**: 23/02/2026

## ✅ Verificação Final Antes de Submeter

- [ ] Todos os 4 membros do grupo incluídos no PDF
- [ ] Todas as 14 questões respondidas (ou 12 se não fez facultativas)
- [ ] Tabelas preenchidas com dados reais (não de exemplo)
- [ ] Figuras de performance incluídas
- [ ] Análises e conclusões bem redigidas
- [ ] Formatação PDF clara e legível
- [ ] Nenhuma erro de ortografia ou gramática
- [ ] Nome do arquivo: `TP4-nom1-nom2-nom3-nom4.pdf`

---

**Última atualização**: Fevereiro de 2026  
**Versão**: 1.0
