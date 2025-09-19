`uvm_analysis_imp_decl(_mon_scb)

`uvm_analysis_imp_decl(_driv_scb)


class apb_scoreboard extends uvm_scoreboard;

  apb_seq_item driver_queue[$];

  apb_seq_item monitor_queue[$];

  int mismatch,match;

  logic [7:0] mem [9:0];

  `uvm_component_utils(apb_scoreboard)

  uvm_analysis_imp_mon_scb#(apb_seq_item, apb_scoreboard) mon_scb_port;

  uvm_analysis_imp_driv_scb#(apb_seq_item, apb_scoreboard) driv_scb_port;

  function new(string name = "apb_scoreboard", uvm_component parent);

    super.new(name, parent);

  endfunction

  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    driv_scb_port = new("driv_scb_port", this);

    mon_scb_port = new("mon_scb_port",this);

  endfunction

  function void write_mon_scb(apb_seq_item packet_1);

    monitor_queue.push_back(packet_1);

  endfunction

  function void write_driv_scb(apb_seq_item packet_2);

    driver_queue.push_back(packet_2);

  endfunction

  task run_phase(uvm_phase phase);

    apb_seq_item act;

    apb_seq_item pass;

    forever begin

      wait(monitor_queue.size() > 0 && driver_queue.size()>0); 

        act = monitor_queue.pop_front();

        pass = driver_queue.pop_front();

		if(!act.PRESETn) begin

			 if(pass.PSLVERR == 0 && pass.apb_read_data_out == 8'b0) begin

			      match++;

			      $display(" Reset is active low \n PSLVERR and apb_read_data_out are set to zero");

				  `uvm_info(get_type_name(),"------------------------------ Passed -------------------------------",UVM_MEDIUM);

	         end

		end

		else begin 

			mismatch++;

			$display(" Reset condition failed \n PSLVERR and apb_read_data_out are not to zero");

			`uvm_info(get_type_name(),"------------------------------ Failed -------------------------------",UVM_MEDIUM);

		end

		if(act.transfer && act.PRESETn == 1) begin

			if(act.READ_WRITE) 

				mem[act.apb_write_paddr] = act.apb_write_data;	

			else begin

                if($isunknown(mem[act.apb_read_paddr]) && pass.PSLVERR) begin

					`uvm_info(get_type_name(),"Bridge is Accessing memory which is not written into",UVM_MEDIUM);

					match++;

				end

				else begin

					if(mem[act.apb_read_paddr] === pass.apb_read_data_out) begin

						match++;

						$display(" Read data matching with the written data");

						`uvm_info(get_type_name(),"------------------------------ Passed -------------------------------",UVM_MEDIUM);

					end

					else begin

             			mismatch++;

             			$display(" Read data not matching with the written data: PRDATA = %d | while data in PRADDR (%d) = %d",pass.apb_read_data_out,act.apb_read_paddr,mem[act.apb_read_paddr]);

             			`uvm_info(get_type_name(),"------------------------------ Failed -------------------------------",UVM_MEDIUM);

                    end

				end // else(mismatch)

			end // transfer-if

          if(pass.apb_read_data_out === $past(pass.apb_read_data_out) && pass.PSLVERR === $past(pass.PSLVERR)) begin

                    match++;

                    $display(" Data is latching to previous value when Transfer = 0");

					`uvm_info(get_type_name(),"------------------------------ Passed -------------------------------",UVM_MEDIUM);

			end

			else begin

                    mismatch++;

                    $display(" Data is not latching to previous value when Transfer = 0");

                    `uvm_info(get_type_name(),"------------------------------ Failed -------------------------------",UVM_MEDIUM);

            end

		//end // wait

		end // forever

  endtask  

endclass
 
