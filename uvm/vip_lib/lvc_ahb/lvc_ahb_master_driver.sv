`ifndef LVC_AHB_MASTER_DRIVER_SV
`define LVC_AHB_MASTER_DRIVER_SV

class lvc_ahb_master_driver extends lvc_ahb_driver;
  lvc_ahb_agent_configuration cfg;
  virtual lvc_ahb_if vif;
  `uvm_component_utils(lvc_ahb_master_driver)

  function new(string name = "lvc_ahb_master_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

  //this task is extends from lvc_ahb_driver
  //(REQ t) means request is a transaction type
  virtual task drive_transfer(REQ t);
    case(t.burst_type)
    SINGLE : begin do_atomic_trans(t); end
    INCR   : begin `uvm_error("TYPEERR", "brust type not supported currently") end
    WRAP4  : begin `uvm_error("TYPEERR", "burst type not supported yet") end
    INCR4  : begin `uvm_error("TYPEERR", "burst type not supported yet") end
    WRAP8  : begin `uvm_error("TYPEERR", "burst type not supported yet") end
    INCR8  : begin `uvm_error("TYPEERR", "burst type not supported yet") end
    WRAP16 : begin `uvm_error("TYPEERR", "burst type not supported yet") end
    INCR16 : begin `uvm_error("TYPEERR", "burst type not supported yet") end
    default: begin `uvm_error("TYPEERR", "burst type not defined") end
    endcase
  endtask

  //do single transfer
  virtual task do_atomic_trans(REQ t);
    case(t.xact_type)
      READ       : do_read(t);
      WRITE      : do_write(t);
      IDLE_XACT : begin `uvm_error("TYPEERR", "trans type not supported yet") end
      default: begin `uvm_error("TYPEERR", "trans type not defined") end 
    endcase
  endtask

  //wait this master got the access from bus
  //if and only if hgrant = 1, than can begin data transfer
  virtual task wait_for_bus_grant();
    @(vif.cb_mst iff vif.cb_mst.hgrant === 1'b1);
  endtask

  virtual task do_write(REQ t);
    do_init_write(t);
    do_porc_write(t);
  endtask

  virtual task do_read(REQ t);
    do_init_read(t);
    do_porc_read(t);
  endtask

  //initial the write operation
  virtual task do_init_write(REQ t);
    wait_for_bus_grant();           //wait this master get the access from bus
    vif.cb_mst.htrans <= NSEQ;
    vif.cb_mst.haddr  <= t.addr;
    vif.cb_mst.hburst <= t.hburst;
    vif.cb_mst.hsize  <= t.hsize;
    vif.cb_mst.hwrite <= 1'b1;      //1 is write, 0 is read

    @(vif.cb_mst);
    if(t.burst_type == SINGLE) begin
      _do_drive_idle();
    end
    vif.cb_mst.hwdata <= t.data[0]; //set write data to the bus

    //forever wait hready = 1, check slave whether ready
    forever begin
      @(negedge vif.hclk);
      if(vif.hready === 1'b1) begin
        break;
      end
      else
        @(vif.cb_mst);
    end

    //updata transfer infomation
    t.trans_type = NSEQ;
    t.current_data_beat_num = 0;
    t.all_beat_response[t.current_data_beat_num] = response_type_enum'(vif.hresp);
  endtask

  virtual task do_init_read(REQ t);
    wait_for_bus_grant();
    @(vif.cb_mst);                      //wait for first clock edge, than do the code below
    vif.cb_mst.htrans <= NSEQ;
    vif.cb_mst.haddr  <= t.addr;
    vif.cb_mst.hburst <= t.brust_type;
    vif.cb_mst.hsize  <= t.hsize;
    vif.cb_mst.hwrite <= 1'b0;

    @(vif.cb_mst)                       //wait for the second clock edge
    if(t.burst_type == SINGLE) begin
      _do_drive_idle();
    end

    forever begin
      @(negedge vif.hclk);
      if(vif.hready === 1'b1) begin
        break;
      end
      elseF
        @(vif.cb_mst)
    end

    t.data = new[t.current_data_beat_num + 1](t.data)
    t.data[0] = vif.hrdata;

    //update current transfer status
    t.trans_type = NSEQ;
    t.current_data_beat_num = 0; // start beat from 0 to make consistence with data array index
    t.all_beat_response[t.current_data_beat_num] = response_type_enum'(vif.hresp);
  endtask

    virtual task do_proc_write(REQ t);
    // TODO implement for SEQ operations of other BURST types
    do_init_idle(t);
  endtask

  virtual task do_proc_read(REQ t);
    // TODO implement for SEQ operations of other BURST types
    do_init_idle(t);
  endtask

  virtual protected task do_init_idle(REQ t);
    @(vif.cb_mst);
    _do_drive_idle();
  endtask

  virtual protected task _do_drive_idle();
    vif.cb_mst.haddr     <= 0;
    vif.cb_mst.hburst    <= 0;
    vif.cb_mst.hbusreq   <= 0;
    vif.cb_mst.hlock     <= 0;
    vif.cb_mst.hprot     <= 0;
    vif.cb_mst.hsize     <= 0;
    vif.cb_mst.htrans    <= 0;
    vif.cb_mst.hwdata    <= 0;
    vif.cb_mst.hwrite    <= 0;
  endtask

  //while UVM running, this task forever run to check whether reset signal is coming
  //if reset be called, automatically turn bus's all signals into IDLE status 
  virtual protected task reset_listener();
    `uvm_info(get_type_name(), "seset_listener ...", UVM_HIGH)
    fork
      forever begin
        @(negedge vif.hresetn);
        _do_drive_idle();
      end
    join_none      //start this forever loop in the background and never stop
  endtask

endclass

`endif // LVC_AHB_MASTER_DRIVER_SV
