`ifndef LVC_AHB_IF_SV
`define LVC_AHB_IF_SV

interface lvc_ahb_if;
  `include "lvc_ahb_defines.svh"
  import lvc_ahb_pkg::*;

  //DUT inputs
  logic                                   hclk;
  logci                                   hresetn;
  logic                                   hready;
  logic [1:0]                             htrans;
  logic [1:0]                             hsize;
  logic                                   hwrite;
  logic [(`LVC_AHB_MAX_ADDR_WIDTH - 1):0] haddr;
  logic [(`LVC_AHB_MAX_DATA_WIDTH - 1):0] hwdata;

  //DUT outputs
  logic                                   hreadyout;
  logic                                   hresp;
  logic [(`LVC_AHB_MAX_DATA_WIDTH - 1):0] hrdata;

  //the signals not exist in DUT
  logic [2:0]                             hburst;
  logic                                   hgrant;   //indicate whether this master currently has the access to the bus (0 or 1)

  //some debug signals for debug 
  response_type_enum                      debug_hresp;
  trans_type_enum                         debug_trans;
  burst_size_type                         debug_hsize;
  burst_type_enum                         debug_hburst;
  xact_type_enum                          debug_xact;
  status_enum                             debug_status;

  //debug signals assignemnt
  //transfer binary type to enum type, is more readable
  assign debug_hresp    = response_type_enum'(hresp);
  assign debug_trans    = trans_type_enum'(htrans);
  assign debug_hsize    = burst_size_type'(hsize);
  assign debug_hburst   = burst_type_enum'(hburst);

  clocking cb_mst @(posedge hclk);
    default input #1ps output #1ps;
    output haddr, hburst, hprot, hsize, htrans, hwdata, hwrite; 
    input hready, hrdata;    
  endclocking 

  clocking cb_slv @(posedge hclk);
   // USER: Add clocking block detail
    default input #1ps output #1ps;
    input haddr, hburst, hprot, hsize, htrans, hwdata, hwrite; 
    output hready, hrdata;
  endclocking : cb_slv

  clocking cb_mon @(posedge hclk);
   // USER: Add clocking block detail
    default input #1ps output #1ps;
    input haddr, hburst, hprot, hsize, htrans, hwdata, hwrite; 
    input hready, hrdata;
  endclocking : cb_mon
endinterface

`endif // LVC_AHB_IF_SV
