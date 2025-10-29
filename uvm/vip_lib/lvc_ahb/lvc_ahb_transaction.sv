`ifndef LVC_AHB_TRANSACTION_SV
`define LVC_AHB_TRANSACTION_SV

class lvc_ahb_transcation extends uvm_sequence_item;

  rand bit [`LVC_AHB_MAX_DATA_WIDTH - 1:0] data[];
  rand bit [`LVC_AHB_MAX_ADDR_WIDTH - 1:0] addr = 0;

  rand burst_size_enum burst_size = BURST_SIZE_8BIT;

  rand burst_type_enum burst_type = SINGLE;

  rand xact_type_enum xact_type = IDLE_XACT;  //表示当前事务是空闲事务，在 AHB 协议中，空闲事务通常用于主设备暂时不发起有效操作时的占位状态。

  rand response_type_enum response_type = OKAY;

  //the member below is possibly to be used later
  trans_type_enum trans_type;                 //当前的传输类型

  response_type_enum all_beat_response[];     //储存所有传输节拍数类型的变量

  int current_data_beat_num;                  //当前传输数据的节拍数类型 4,8,16

  status_enum status = INITIAL;               //事务当前的状态初始化为初始状态

  rand bit idle_xact_hwrite = 1;              //空闲事务时的hwrite的信号值，初始化为1，表示空闲事务默认模拟写操作

  `uvm_object_utils_begin(lvc_ahb_transaction)//域的自动化，将上定义的变量注册到机制中，即可支持compare,print,copy,pack,unpack,覆盖率收集等功能
    `uvm_field_array_int(data, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_enum(burst_size_enum, burst_size, UVM_ALL_ON)
    `uvm_field_enum(burst_type_enum, burst_type, UVM_ALL_ON)
    `uvm_field_enum(xact_type_enum, xact_type, UVM_ALL_ON)
    `uvm_field_enum(response_type_enum, response_type, UVM_ALL_ON)
    `uvm_field_enum(trans_type_enum, trans_type, UVM_ALL_ON)
    `uvm_field_array_enum(response_type_enum, all_beat_response, UVM_ALL_ON)
    `uvm_field_int(adcurrent_data_beat_numdr, UVM_ALL_ON)
    `uvm_field_enum(status_enum, status, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "lvc_ahb_transaction");
    super.new(name);  
  endfunction
endclass

`endif // LVC_AHB_TRANSACTION_SV
