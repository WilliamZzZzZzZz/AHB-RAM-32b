`ifndef RKV_AHBRAM_IF_SV
`define RKV_AHBRAM_IF_SV

interface rkv_ahbram_if;
  logic clk;
  logic rstn;

  initial begin : rstn_gen    //自动生成复位信号
    assert_reset(10);         //仿真开始时默认保持10个时钟周期的低电平
  end
  
  //这个task的作用就是初始化DUT
  task automatic assert_reset(int nclks = 1, int delay = 0);
    #(delay * 1ns);                   //默认延迟0ns
    repeat(nclks) @(posedge clk);     //等待nclks个上升沿，nclks设置为了1
    rstn <= 0;                        //等待完成后复位信号拉低，即进入复位状态
    repeat(5) @(posedge clk);         //再等待5个上升沿
    rstn <= 1;                        //将复位信号再恢复到高电平1
  endtask

endinterface

`endif // RKV_AHBRAM_IF_SV