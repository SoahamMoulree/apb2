`include "defines.svh"
class apb_monitor extends uvm_monitor;

  `uvm_component_utils(apb_monitor)
  
  virtual apb_intf vif;
  
  uvm_analysis_port #(apb_seq_item) mon_port;
  uvm_analysis_port #(apb_seq_item) act_mon_cov_port;
  uvm_analysis_port #(apb_seq_item) pas_mon_cov_port;
  
  function new(string name="apb_monitor",uvm_component parent);
    super.new(name,parent);
    mon_port=new("mon_port",this);
    act_mon_cov_port = new("act_mon_cov_port",this);
    pas_mon_cov_port = new("pas_mon_cov_port",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_intf)::get (this,"","vif",vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),"vif"});
  
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
        apb_seq_item seq;
        seq=apb_seq_item::type_id::create("seq",this);
      seq.READ_WRITE=vif.mon_cb.READ_WRITE;
      seq.apb_read_data_out=vif.mon_cb.apb_read_data_out;
      seq.PSLVERR=vif.mon_cb.PSLVERR;
      seq.apb_read_paddr=vif.apb_read_paddr;
      seq.apb_write_paddr=vif.apb_write_paddr;
      seq.apb_write_data=vif.apb_write_data;
      act_mon_cov_port.write(seq);
      pas_mon_cov_port.write(seq);
                  
                  `uvm_info("MON",$sformatf("MON VALUES rdata=%d,read address=%d,wdata=%d,pslverr=%d,write address=%d",seq.apb_read_data_out,seq.apb_read_paddr,seq.apb_write_data,seq.PSLVERR,seq.apb_write_paddr),UVM_LOW);
                
                  
                            seq.print();
      
      mon_port.write(seq);
      repeat(3)@(posedge vif.mon_cb);

                            end
                            endtask
                            endclass
                            
    
    
