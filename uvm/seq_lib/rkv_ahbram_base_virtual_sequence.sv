`ifndef RKV_AHBRAM_BASE_VIRTUAL_SEQUENCE_SV
`define RKV_AHBRAM_BASE_VIRTUAL_SEQUENCE_SV

class rkv_ahbram_base_virtual_sequence extends uvm_sequence;

  //declartion
  rkv_ahbram_config cfg;
  virtual rkv_ahbram_if vif;
  rkv_ahbram_rgm rgm;
  bit[31:0] wr_val, rd_val;
  uvm_status_e status;

  //declare some element sequence
  rkv_ahbram_single_write_seq single_write;
endclass

`endif  
