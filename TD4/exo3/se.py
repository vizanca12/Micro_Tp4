# tp4_se_cache.py
import argparse
import m5
from m5.objects import (
    System, Root, Process, SEWorkload,
    SrcClockDomain, VoltageDomain, AddrRange,
    DerivO3CPU, TimingSimpleCPU, MinorCPU,
    SystemXBar, MemCtrl, DDR3_1600_8x8,
    Cache, L2XBar,
)

class L1ICache(Cache):
    tag_latency = 2
    data_latency = 2
    response_latency = 2
    mshrs = 4
    tgts_per_mshr = 8
    is_read_only = True

    def __init__(self, size: str, assoc: int):
        super().__init__()
        self.size = size
        self.assoc = assoc

class L1DCache(Cache):
    tag_latency = 2
    data_latency = 2
    response_latency = 2
    mshrs = 8
    tgts_per_mshr = 8

    def __init__(self, size: str, assoc: int):
        super().__init__()
        self.size = size
        self.assoc = assoc

class L2Cache(Cache):
    tag_latency = 10
    data_latency = 10
    response_latency = 10
    mshrs = 16
    tgts_per_mshr = 12

    def __init__(self, size: str, assoc: int):
        super().__init__()
        self.size = size
        self.assoc = assoc

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--cmd", required=True)
    ap.add_argument("--args", default="")
    ap.add_argument("--cpu-type", choices=["O3", "TimingSimpleCPU", "MinorCPU"], default="TimingSimpleCPU")
    ap.add_argument("--cpu-clock", default="1GHz")
    ap.add_argument("--mem-size", default="2GB")
    ap.add_argument("--config", choices=["C1", "C2"], default="C1")
    args = ap.parse_args()

    if args.config == "C1":
        l1i_assoc, l1d_assoc, l2_assoc = 1, 1, 1
    else:
        l1i_assoc, l1d_assoc, l2_assoc = 1, 2, 4

    system = System()
    system.clk_domain = SrcClockDomain(clock=args.cpu_clock, voltage_domain=VoltageDomain())
    system.mem_mode = "timing"
    system.mem_ranges = [AddrRange(args.mem_size)]
    system.cache_line_size = 32

    if args.cpu_type == "O3":
        system.cpu = DerivO3CPU()
        system.cpu.fetchBufferSize = 32
    elif args.cpu_type == "MinorCPU":
        system.cpu = MinorCPU()
    else:
        system.cpu = TimingSimpleCPU()

    system.membus = SystemXBar()
    system.system_port = system.membus.cpu_side_ports
    system.cpu.createInterruptController()

    system.cpu.icache = L1ICache("4kB", l1i_assoc)
    system.cpu.dcache = L1DCache("4kB", l1d_assoc)
    system.l2bus = L2XBar()
    system.l2cache = L2Cache("32kB", l2_assoc)

    system.cpu.icache_port = system.cpu.icache.cpu_side
    system.cpu.dcache_port = system.cpu.dcache.cpu_side

    system.cpu.icache.mem_side = system.l2bus.cpu_side_ports
    system.cpu.dcache.mem_side = system.l2bus.cpu_side_ports

    system.l2cache.cpu_side = system.l2bus.mem_side_ports
    system.l2cache.mem_side = system.membus.cpu_side_ports

    system.mem_ctrl = MemCtrl()
    system.mem_ctrl.dram = DDR3_1600_8x8()
    system.mem_ctrl.dram.range = system.mem_ranges[0]
    system.mem_ctrl.port = system.membus.mem_side_ports

    system.workload = SEWorkload.init_compatible(args.cmd)
    process = Process()
    process.cmd = [args.cmd] + (args.args.split() if args.args else [])
    system.cpu.workload = process
    system.cpu.createThreads()

    root = Root(full_system=False, system=system)
    m5.instantiate()
    exit_event = m5.simulate()
    m5.stats.dump()
    print(f"Exiting @ tick {m5.curTick()} because {exit_event.getCause()}")

main()
