# Como Compilar Dijkstra para RISC-V

## Problema Encontrado

Erro ao compilar com `riscv64-unknown-elf-gcc`:
```
cannot find crt0.o: No such file or directory
cannot find -lc: No such file or directory
cannot find -lgloss: No such file or directory
```

## Solução

O problema é que `riscv64-unknown-elf-gcc` é um compilador **bare-metal** sem as bibliotecas padrão do C. Existem várias soluções:

### Opção 1: Usar `riscv64-linux-gnu-gcc` (RECOMENDADO)

Este compilador tem as bibliotecas padrão do Linux:

```bash
# Instalar (se necessário)
sudo apt-get install gcc-riscv64-linux-gnu

# Compilar Dijkstra
riscv64-linux-gnu-gcc -O2 -o dijkstra_small dijkstra_small.c

# Testar com gem5
/home/vizanca/gem5/build/X86/gem5.opt -c gem5_config.py \
    --binary=./dijkstra_small
```

### Opção 2: Compilar como Bare-Metal com Newlib

Se você quer usar o compilador bare-metal, precisa instalar a biblioteca Newlib:

```bash
# Instalar newlib (se não tiver)
sudo apt-get install libnewlib-dev

# Compilar
riscv64-unknown-elf-gcc -O2 -o dijkstra_small dijkstra_small.c
```

### Opção 3: Usar binários ARM já existentes

Você já tem `bftest` compilado em ARM. Pode-se usar gem5 com arquitetura ARM:

```bash
/home/vizanca/gem5/build/ARM/gem5.opt -c gem5_config_arm.py \
    --binary=./archive/ES201-TP/TP4/Projet/blowfish/bftest
```

## Recomendação para o TP4

**Solução mais simples:** Use a Opção 1 com `riscv64-linux-gnu-gcc`

Passo a passo:

1. **Instale o compilador:**
   ```bash
   sudo apt-get install gcc-riscv64-linux-gnu
   ```

2. **Verifique a instalação:**
   ```bash
   riscv64-linux-gnu-gcc --version
   ```

3. **Compile os programas:**
   ```bash
   riscv64-linux-gnu-gcc -O2 -o dijkstra_small dijkstra_small.c
   riscv64-linux-gnu-gcc -O2 -o dijkstra_large dijkstra_large.c
   ```

4. **Execute com gem5:**
   ```bash
   /home/vizanca/gem5/build/X86/gem5.opt -c gem5_config.py \
       --binary=./dijkstra_small
   ```

## Arquivos Fonte

Os arquivos Dijkstra estão em:
- `archive/ES201-TP/TP4/Projet/dijkstra/dijkstra_small.c`
- `archive/ES201-TP/TP4/Projet/dijkstra/dijkstra_large.c`

E os do BlowFish:
- `archive/ES201-TP/TP4/Projet/blowfish/bftest.c`
- `archive/ES201-TP/TP4/Projet/blowfish/bftest` (já compilado)

## Próximos Passos

Após compilar, execute as simulações gem5 com diferentes configurações de cache para medir performance e fazer a análise do TP4.
