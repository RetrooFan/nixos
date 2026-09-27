{ pkgs, ... }: {
  environment.etc."htoprc".text = ''
# ------------------------------------------------
hide_userland_threads=1
show_cpu_frequency=1
show_cpu_temperature=1

color_scheme=5

column_meters_0=LeftCPUs Memory Swap DiskIO NetworkIO
column_meter_modes_0=1 1 1 2 2
column_meters_1=RightCPUs Tasks LoadAverage Uptime Battery
column_meter_modes_1=1 2 2 2 2

screen:Main=STARTTIME PPID PID USER PRIORITY NICE M_VIRT M_RESIDENT M_SHARE STATE PERCENT_CPU PERCENT_MEM TIME Command
.sort_key=STARTTIME
.sort_direction=-1

screen:I/O=STARTTIME PPID PID USER IO_PRIORITY IO_RATE IO_READ_RATE IO_WRITE_RATE PERCENT_SWAP_DELAY PERCENT_IO_DELAY Command
.sort_key=IO_RATE
.sort_direction=-1
# ------------------------------------------------
  '';
}
