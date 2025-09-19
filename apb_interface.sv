interface apb_intf(input bit PCLK, PRESETn, transfer);
  
  bit READ_WRITE; // to check the mode of transfer
  bit [8:0] apb_write_paddr; // address where data has to be written
  bit [8:0] apb_read_paddr; // address from where data has to be read
  bit [7:0] apb_write_data; // data that has to be written
  bit [7:0] apb_read_data_out; // data that has to be read
  bit  PSLVERR; // error bit
  // driver clocking block
  clocking drv_cb@(posedge PCLK);
    default input #0 output #0;
    output READ_WRITE, apb_write_paddr, apb_read_paddr, apb_write_data;
    input apb_read_data_out, PSLVERR;
  endclocking
  
  // monitor clocking block
  clocking mon_cb@(posedge PCLK);
    default input #0 output #0;
    output apb_read_data_out, PSLVERR;
    input READ_WRITE, apb_write_paddr, apb_read_paddr, apb_write_data;    
  endclocking
  
  // modport for driver  
  modport DRV(clocking drv_cb, input PCLK, transfer, PRESETn);
  
  // modport for monitor
    
  modport MON(clocking mon_cb, input PCLK, transfer, PRESETn);
    
endinterface
