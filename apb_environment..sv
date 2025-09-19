class apb_env extends uvm_env;
  
	`uvm_component_utils(apb_env)
	apb_agent agt_act, agt_pass;
	apb_scoreboard scb;
	//apb_coverage cov;

	function new(string name = "apb_env", uvm_component parent);
		super.new(name,parent);
	endfunction	

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agt_act = apb_agent::type_id::create("agt_act",this);
		agt_pass = apb_agent::type_id::create("agt_pass",this);
		set_config_int("agt_pass","is_active",UVM_PASSIVE);
		set_config_int("agt_act","is_active",UVM_ACTIVE);
		scb = apb_scoreboard::type_id::create("scb",this);
		//cov = apb_coverage::type_id::create("cov",this);     	
	endfunction	

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agt_act.mon_act.item_collected_port.connect(scb.item_act_port);
		agt_pass.mon_pass.item_collected_port.connect(scb.item_pass_port); 
		
        //agt_act.mon_act.act_mon_cov_port.connect(cov.a_mon_cov_imp); // For coverage from active monitor
        //agt_pass.mon_pass.pas_mon_cov_port.connect(cov.p_mon_cov_imp); // For coverage from passive monitor
	endfunction	
endclass
