`ifndef LVC_AHB_MASTER_AGENT_SV
`define LVC_AHB_MASTER_AGENT_SV

class lvc_ahb_master_agent extends uvm_agent;
  //declare
  lvc_ahb_master_configuration cfg;

  lvc_ahb_master_driver driver;

  lvc_ahb_master_monitor monitor;

  lvc_ahb_master_sequencer sequencer;

  virtual lvc_ahb_if vif;

  `uvm_component_utils(lvc_ahb_master_agent)

  function new(string name = "lvc_ahb_master_agent", uvm_componnent parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(lvc_ahb_agent_configuration)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal("GETCFG", "cannot get agent configuration from config db")
    end
    if(!uvm_conifg_db#(virtual lvc_ahb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("GETVIF", "cannot get interface from config db")
    end
    //instantiate
    monitor = lvc_ahb_master_monitor::type_id::create("monitor", this);

    if(cif.is_active) begin
      driver = lvc_ahb_master_driver::type_id::create("driver", this);
      sequencer = lvc_ahb_master_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.new(phase);
    monitor.vif = vif;
    if(cfg.is_active) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
      driver.vif = vif;
      sequencer.vif = vif;
    end
  endfunction

  task run_phase(uvm_phase phase);
    super.new(phase);
  endtask
endclass

`endif // LVC_AHB_MASTER_AGENT_SV
