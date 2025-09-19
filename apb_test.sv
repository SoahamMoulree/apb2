 class test extends uvm_test;
	`uvm_component_utils(test)

	apb_env env;
	apb_sequence seq;

	function new(string name = "test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = apb_env::type_id::create("env",this);
		seq = apb_sequence::type_id::create("seq");
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this,"Test started");
		seq.start(env.agt_act.seqr);
		phase.drop_objection(this,"End of Test");
	endtask

	virtual function void end_of_elaboration();
		print();
	endfunction
endclass
