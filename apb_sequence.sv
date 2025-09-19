`include "defines.svh"

class apb_sequence extends uvm_sequence#(apb_seq_item);
  
  // factory registeration
  `uvm_component_utils(apb_sequence)
  
  // declaring a seq_item that has to be sent to the driver
  apb_seq_item req;
  
  //new constructor
  function new(string name = "apb_sequence");
    super.new("apb_sequence");
  endfunction
  
  task body();
    
    req = apb_seq_item::type_id::create("req");//creating seq_item
    repeat(`num_of_txns) begin
      start_item(req);
      assert(req.randomize());
      `uvm_info(get_type_name(), $sformatf("| SEQUENCE GENERATED | READ_WRITE = %0b | apb_write_paddr = %9b | apb_read_paddr = %9b | apb_write_data = %8d | ",req.READ_WRITE,req.apb_write_paddr,req.apb_read_paddr, req.apb_write_data),UVM_MEDIUM);
      finish_item(req);
    end
  endtask
endclass
/*
class transfer_test extends apb_sequence#(apb_seq_item);
  
  `uvm_component_utils(transfer_test)
  
  apb_seq_item req;
  
  function new(string name = "transfer_test");
    super.new("name");
  endfunction
  
  task body();
    req = apb_seq_item::type_id::create("req");//creating seq_item
    repeat(`num_of_txns) begin
      `uvm_do_with(req,{
    end
  endtask
  
endclass
*/
