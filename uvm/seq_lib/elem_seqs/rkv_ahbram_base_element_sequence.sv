`ifndef RKV_AHBRAM_BASE_ELEMENT_SEQUENCE_SV
`define RKV_AHBRAM_BASE_ELEMENT_SEQUENCE_SV

class rkv_ahbram_base_element_sequence extends uvm_sequence;

    //declaration
    rkv_ahbram_config cfg;
    virtual rkv_ahbram_if vif;
    rkv_ahbram_rgm rgm;
    bit[31:0] wr_val, rd_val;
    uvm_status_e status;

    `uvm_object_utils(rkv_ahbram_base_element_sequence);
    //this operation will automatically declare a "p_sequencer" in current sequence
    //this "p_sequencer" is the type of "rkv_ahbram_virtual_sequencer"
    //current sequence could access "rkv_ahbram_virtual_sequencer" via "p_sequencer" 
    `uvm_declare_p_sequencer(rkv_ahbram_virtual_sequencer);

    function new(string name = "rkv_ahbram_base_element_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info("body", "Entering task body...", UVM_LOW)
        //get the cfg from "ahbram_virtual_sequencer" via p_sequencer
        cfg = p_sequencer.cfg;
        vif = cfg.vif;
        rgm = cfg.rgm;
        `uvm_info("body", "Existing task body...", UVM_LOW)
    endtask

    //a function which compare two inputs data
    virtual function void compare_data(logic[31:0] val1, logic[31:0] val2);
        cfg.seq_check_count++;
        if(val1 === val2)
            `uvm_info("CMPSUC", $sformatf("val1 'h%0x === val2 'h%0x", val1, val2), UVM_LOW)
        else begin
            cfg.seq_check_error++;
            `uvm_error("CMPERR", $sformatf("val1 'h%0x !== val2 'h%0x", val1, val2))
        end
    endfunction

endclass

`endif