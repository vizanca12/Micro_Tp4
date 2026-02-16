import argparse, m5
from m5.objects import *
def parse_args():
    ap = argparse.ArgumentParser()
    ap.add_argument("--cmd", required=True); ap.add_argument("--args", default="")
    ap.add_argument("--l1_size", default="1kB")
    return ap.parse_args()
args = parse_args()
system = System(clk_domain=SrcClockDomain(clock="1GHz", voltage_domain=VoltageDomain()), mem_mode="timing", mem_ranges=[AddrRange("2GB")], cache_line_size=32)
system.membus = SystemXBar(); system.l2bus = L2XBar()
system.cpu = DerivO3CPU(fetchBufferSize=32, fetchQueueSize=4, decodeWidth=2, issueWidth=4, commitWidth=2, fetchWidth=2, renameWidth=2, dispatchWidth=2, wbWidth=2)

system.cpu.numROBEntries = 2; system.cpu.numIQEntries = 2; system.cpu.LQEntries = 8; system.cpu.SQEntries = 8
system.cpu.branchPred = BiModeBP(BTBEntries=256)
system.cpu.icache = Cache(size=args.l1_size, assoc=2, tag_latency=2, data_latency=2, response_latency=2, mshrs=4, tgts_per_mshr=20)
system.cpu.dcache = Cache(size=args.l1_size, assoc=2, tag_latency=2, data_latency=2, response_latency=2, mshrs=4, tgts_per_mshr=20)
system.l2cache = Cache(size="512kB", assoc=8, tag_latency=10, data_latency=10, response_latency=10, mshrs=20, tgts_per_mshr=12)
system.cpu.icache.cpu_side = system.cpu.icache_port; system.cpu.dcache.cpu_side = system.cpu.dcache_port
system.cpu.icache.mem_side = system.l2bus.cpu_side_ports; system.cpu.dcache.mem_side = system.l2bus.cpu_side_ports
system.l2cache.cpu_side = system.l2bus.mem_side_ports; system.l2cache.mem_side = system.membus.cpu_side_ports; system.system_port = system.membus.cpu_side_ports
system.mem_ctrl = MemCtrl(dram=DDR3_1600_8x8(range=system.mem_ranges[0]), port=system.membus.mem_side_ports)
system.cpu.workload = Process(cmd=[args.cmd] + args.args.split())
system.workload = SEWorkload.init_compatible(args.cmd)
system.cpu.createThreads(); system.cpu.createInterruptController()
root = Root(full_system=False, system=system)
m5.instantiate(); m5.simulate(); m5.stats.dump()
