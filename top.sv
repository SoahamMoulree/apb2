`include "uvm_macros.svh"
import uvm_pkg::*;
`include "apb_interface.sv"
`include "apb_pkg.sv"
import apb_pkg::*; 
`include "apbtop.v"
module top;
  bit clk;
  bit reset;
  
  always clk = ~clk;
  
  APB_Protocol dut(clk,reset,intf.transfer,intf.READ_WRITE,intf.apb_write_paddr,intf.apb_write_data,intf.apb_read_paddr,intf.PSLVERR,intf.apb_read_data_out);

  apb_intf intf(clk,reset,transfer);

  initial begin
   uvm_config_db#(virtual apb_intf)::set(uvm_root::get(),"*","vif",intf);
  end

  initial begin
    run_test("test");
    #100 $finish;
  end
endmodule
