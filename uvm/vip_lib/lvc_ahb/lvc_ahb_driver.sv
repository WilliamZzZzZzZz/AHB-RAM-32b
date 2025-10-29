`ifndef LVC_AHB_DRIVER_SV
`define LVC_AHB_DRIVER_SV

class lvc_ahb_driver #(type REQ = lvc_ahb_transaction, type RSP = REQ) extends uvm_driver #(REQ, RSP);
  `uvm_component_utils(lvc_ahb_driver)

  function new(string name = "lvc_ahb_driver", uvm_component parent = null);
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
    fork
      get_and_drive();
      reset_listener();
    join_none
  endtask

  virtual task get_and_drive();
    forever begin
      seq_item_port.get_next_item(req);               //获取事务，将事务存储到req之中
      `uvm_info(get_type_name(), "sequencer got next item", UVM_HIGH)

      driver_transfer(req);                           //将请求到的事务req转换为DUT所需的信号类型
      void`($cast(rsp,req.clone()));                  //克隆req并赋值给rsp
      rsp.set_sequence_id(req.get_sequence_id());     //不仅要赋值，还需要将rsp的序列id设置为req的序列id
      rsp.set_transaction_id(req.get_transaction());  //将rsp的事务id设置为req的事务id

      seq_item_port.item_done(rsp);                   //当前事务已经完成，并将响应rsp返回给sequencer
      `uvm_info(get_type_name(),"sequencer item has done", UVM_HIGH)
    end
  endtask

  virtual task drive_transfer(REQ t);

  endtask

  virtual task reset_listener();

  endtask
  
endclass

`endif // LVC_AHB_DRIVER_SV
