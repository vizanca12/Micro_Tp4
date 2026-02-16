# -*- coding: utf-8 -*-
import argparse
import m5
from m5.objects import *

def parse_args():
    ap = argparse.ArgumentParser()
    ap.add_argument("--cmd", required=True)
    ap.add_argument("--args", default="")
    ap.add_argument("--l1_size", default="32kB")
    return ap.parse_args()

def build_system(args):
    system = System()
    system.clk_domain = SrcClockDomain(clock="1GHz", voltage_domain=VoltageDomain())
    system.mem_mode = "timing"
    system.mem_ranges = [AddrRange("2GB")]
    system.cache_line_size = 64

    system.membus = SystemXBar()
    system.l2bus = L2XBar()

    system.cpu = DerivO3CPU()
    system.cpu.fetchBufferSize = 64
    system.cpu.fetchQueueSize = 8
    
    system.cpu.decodeWidth = 4
    system.cpu.issueWidth = 8
    system.cpu.commitWidth = 4
    system.cpu.fetchWidth = 4
    system.cpu.renameWidth = 4
    system.cpu.dispatchWidth = 4
    system.cpu.wbWidth = 4
    
    system.cpu.numROBEntries = 16
    system.cpu.numIQEntries = 16
    system.cpu.LQEntries = 8
    system.cpu.SQEntries = 8

    system.cpu.icache = Cache(size=args.l1_size, assoc=2, tag_latency=2, data_latency=2, response_latency=2, mshrs=4, tgts_per_mshr=20)
    system.cpu.dcache = Cache(size=args.l1_size, assoc=2, tag_latency=2, data_latency=2, response_latency=2, mshrs=4, tgts_per_mshr=20)
    
    system.l2cache = Cache(size="512kB", assoc=16, tag_latency=10, data_latency=10, response_latency=10, mshrs=20, tgts_per_mshr=12)

    system.cpu.icache.cpu_side = system.cpu.icache_port
    system.cpu.dcache.cpu_side = system.cpu.dcache_port
    system.cpu.icache.mem_side = system.l2bus.cpu_side_ports
    system.cpu.dcache.mem_side = system.l2bus.cpu_side_ports
    
    system.l2cache.cpu_side = system.l2bus.mem_side_ports
    system.l2cache.mem_side = system.membus.cpu_side_ports
    system.system_port = system.membus.cpu_side_ports

    system.mem_ctrl = MemCtrl()
    system.mem_ctrl.dram = DDR3_1600_8x8()
    system.mem_ctrl.dram.range = system.mem_ranges[0]
    system.mem_ctrl.port = system.membus.mem_side_ports

    process = Process()
    cmd_list = [args.cmd]
    if args.args: cmd_list += args.args.split()
    process.cmd = cmd_list
    
    system.workload = SEWorkload.init_compatible(args.cmd)
    system.cpu.workload = process
    system.cpu.createThreads()
    system.cpu.createInterruptController()

    return system

def main():
    args = parse_args()
    system = build_system(args)
    root = Root(full_system=False, system=system)
    m5.instantiate()
    m5.simulate()
    m5.stats.dump()

main()
