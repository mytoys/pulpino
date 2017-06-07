if { ![info exists ::env(BOARD) ]} {
  set ::env(BOARD) "zedboard"
}

if { ![info exists ::env(XILINX_PART)] } {
  if {[string equal $::env(BOARD) "zybo"]} {
    puts "Running implementation for ZYBO board"
    set ::env(XILINX_PART) "xc7z010clg400-1"
  } {
    set ::env(XILINX_PART) "xc7z020clg484-1"

    if { ![info exists ::env(XILINX_BOARD)] } {
      set ::env(XILINX_BOARD) "em.avnet.com:zynq:zed:c"
    }
  }
}


set RTL ../../rtl
set IPS ../../ips
set FPGA_IPS ../ips
set FPGA_RTL ../rtl
set FPGA_PULPINO ../pulpino

# create project
create_project arty_top . -part $::env(XILINX_PART) -force

if { [info exists ::env(XILINX_BOARD) ] } {
  set_property board $::env(XILINX_BOARD) [current_project]
}


# set up meaningful errors
source ../common/messages.tcl

# add arty_top
add_files -norecurse ../rtl/arty_top.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# add pulpino
add_files -norecurse ../arty_pulpino/pulpino.edf \
                     ../arty_pulpino/pulpino_stub.v \
                     ../ips/arty_mmcm/ip/arty_mmcm.dcp

update_compile_order -fileset sources_1

add_files -fileset constrs_1 -norecurse constraints.xdc

# save area
set_property strategy Flow_AreaOptimized_High [get_runs synth_1]

# synthesize
synth_design -rtl -name rtl_1

launch_runs synth_1
wait_on_run synth_1
open_run synth_1 -name netlist_1
# write_edif arty_top.edf


# run implementation
source tcl/impl.tcl
