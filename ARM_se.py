# ARM_TP4.py - Versao Final 8.0 (Interrupt Controller Fix)
import argparse

from gem5.utils.requires import requires
from gem5.isas import ISA
from gem5.components.boards.simple_board import SimpleBoard
from gem5.components.processors.simple_processor import SimpleProcessor
from gem5.components.processors.cpu_types import CPUTypes
from gem5.components.memory import SingleChannelDDR3_1600
from gem5.resources.resource import BinaryResource
from gem5.simulate.simulator import Simulator

from gem5.components.cachehierarchies.classic.abstract_classic_cache_hierarchy import AbstractClassicCacheHierarchy
from gem5.components.cachehierarchies.classic.caches.l1dcache import L1DCache
from gem5.components.cachehierarchies.classic.caches.l1icache import L1ICache
from gem5.components.cachehierarchies.classic.caches.l2cache import L2Cache
from gem5.components.cachehierarchies.classic.caches.mmu_cache import MMUCache
from m5.objects import L2XBar, SystemXBar, Port

class TP4CacheHierarchy(AbstractClassicCacheHierarchy):
    def __init__(self, config_mode):
        super().__init__()
        self._config_mode = config_mode
        self.membus = SystemXBar()

    def get_mem_side_port(self) -> Port:
        return self.membus.mem_side_ports

    def get_cpu_side_port(self) -> Port:
        return self.membus.cpu_side_ports

    def incorporate_cache(self, board):
        board.connect_system_port(self.membus.cpu_side_ports)
        for _, port in board.get_memory().get_mem_ports():
            self.membus.mem_side_ports = port

        if self._config_mode == "C1":
            l1i_assoc = 1
            l1d_assoc = 1
            l2_assoc  = 1
        elif self._config_mode == "C2":
            l1i_assoc = 1
            l1d_assoc = 2
            l2_assoc  = 4
        else:
            raise ValueError("Use --config C1 or --config C2")

        for core in board.get_processor().get_cores():
            # 1. Ajustar fetch buffer para 32 bytes
            core.core.fetchBufferSize = 32

            # --- FIX FINAL: Criar Controlador de Interrupcao (GIC) ---
            # Obrigatorio para ARM, senao da erro fatal na inicializacao
            core.core.createInterruptController()

            # --- L1 & L2 Caches ---
            core.l1i = L1ICache(size="4kB", assoc=l1i_assoc)
            core.l1d = L1DCache(size="4kB", assoc=l1d_assoc)
            core.l2 = L2Cache(size="32kB", assoc=l2_assoc)

            # Connections L1 -> Core
            core.connect_icache(core.l1i.cpu_side)
            core.connect_dcache(core.l1d.cpu_side)

            # L2 Bus
            core.l2_bus = L2XBar()
            core.l1i.mem_side = core.l2_bus.cpu_side_ports
            core.l1d.mem_side = core.l2_bus.cpu_side_ports
            core.l2.cpu_side = core.l2_bus.mem_side_ports
            core.l2.mem_side = self.membus.cpu_side_ports

            # --- MMU SETUP (Bus + Walkers) ---
            core.mmu_cache = MMUCache(size="8kB")
            core.mmu_bus = L2XBar()
            
            # Bus -> MMU Cache
            core.mmu_bus.mem_side_ports = core.mmu_cache.cpu_side
            
            # MMU Cache -> System
            core.mmu_cache.mem_side = self.membus.cpu_side_ports

            # Walkers -> Bus
            core.connect_walker_ports(
                core.mmu_bus.cpu_side_ports, core.mmu_bus.cpu_side_ports
            )

parser = argparse.ArgumentParser()
parser.add_argument("-b", "--binary", required=True, help="Path to binary")
parser.add_argument("--config", default="C1", choices=["C1", "C2"], help="Config C1 or C2")
args = parser.parse_args()

requires(isa_required=ISA.ARM)

cache_hierarchy = TP4CacheHierarchy(config_mode=args.config)
memory = SingleChannelDDR3_1600(size="8GB")
processor = SimpleProcessor(cpu_type=CPUTypes.O3, isa=ISA.ARM, num_cores=1)

board = SimpleBoard(
    clk_freq="1GHz",
    processor=processor,
    memory=memory,
    cache_hierarchy=cache_hierarchy
)

# Set Cache Line Size manually
board.cache_line_size = 32

board.set_se_binary_workload(BinaryResource(args.binary))
sim = Simulator(board=board)
print(f"Running simulation with config {args.config}...")
sim.run()