class apb_driver extends uvm_driver #(apb_seq_item);
 
   virtual apb_intf vif;
 
  `uvm_component_utils(apb_driver)
 
  function new(string name = " apb_driver", uvm_component parent);
 
    super.new(name,parent);
 
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_intf)::get(this,"","vif",vif))
       `uvm_fatal(get_type_name(),"failed to get interface signals");
  endfunction
 
       virtual task run_phase(uvm_phase phase);
   apb_seq_item req;
 forever begin
     seq_item_port.get_next_item(req);
        drive(req);
        seq_item_port.item_done();
    end
 
  endtask
 
 task drive(apb_seq_item req);
      if(vif.transfer)begin
      repeat(1) @(vif.drv_cb);//goes to setup_phase  
        vif.drv_cb.READ_WRITE <= req.READ_WRITE;
        if(vif.drv_cb.READ_WRITE)begin //Write Transfer
           vif.drv_cb.apb_write_paddr <= req.apb_write_paddr;
         vif.drv_cb.apb_write_data <= req.apb_write_data;
        end

        else begin //Read Transfer

           vif.drv_cb.apb_read_paddr <= req.apb_read_paddr;

        end
 
        $display("time[%0t] DRIVER DRIVING signals to DUT .........Transfer = %0d, READ_WRITE=%0d, apb_write_paddr=%0d, apb_read_paddr=%0d, apb_write_data=%0d", $time,vif.transfer, vif.drv_cb.READ_WRITE, vif.drv_cb.apb_write_paddr, vif.drv_cb.apb_read_paddr,vif.drv_cb.apb_write_data);
 
        repeat(1) @(vif.drv_cb);//access phase

      end

      else begin

        vif.drv_cb.READ_WRITE <= 0;

        vif.drv_cb.apb_write_paddr <= 0;

        vif.drv_cb.apb_write_data <= 0;

        vif.drv_cb.apb_read_paddr <= 0;

        $display("time[%0t] DRIVER DRIVING signals to DUT .........Transfer = %0d, READ_WRITE=%0d, apb_write_paddr=%0d, apb_read_paddr=%0d, apb_write_data=%0d", $time,vif.transfer, vif.drv_cb.READ_WRITE, vif.drv_cb.apb_write_paddr, vif.drv_cb.apb_read_paddr,vif.drv_cb.apb_write_data);

         repeat(1) @(vif.drv_cb);

      end

    endtask
 
endclass
 
 
 
