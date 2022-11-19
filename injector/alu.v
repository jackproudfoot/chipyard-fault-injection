module ALUUnit(
  input         clock,
  input         reset,
  input         io_req_valid,
  input  [6:0]  io_req_bits_uop_uopc,
  input         io_req_bits_uop_is_rvc,
  input  [3:0]  io_req_bits_uop_ctrl_br_type,
  input  [1:0]  io_req_bits_uop_ctrl_op1_sel,
  input  [2:0]  io_req_bits_uop_ctrl_op2_sel,
  input  [2:0]  io_req_bits_uop_ctrl_imm_sel,
  input  [3:0]  io_req_bits_uop_ctrl_op_fcn,
  input         io_req_bits_uop_ctrl_fcn_dw,
  input  [2:0]  io_req_bits_uop_ctrl_csr_cmd,
  input         io_req_bits_uop_is_br,
  input         io_req_bits_uop_is_jalr,
  input         io_req_bits_uop_is_jal,
  input         io_req_bits_uop_is_sfb,
  input  [7:0]  io_req_bits_uop_br_mask,
  input  [2:0]  io_req_bits_uop_br_tag,
  input  [3:0]  io_req_bits_uop_ftq_idx,
  input         io_req_bits_uop_edge_inst,
  input  [5:0]  io_req_bits_uop_pc_lob,
  input         io_req_bits_uop_taken,
  input  [19:0] io_req_bits_uop_imm_packed,
  input  [4:0]  io_req_bits_uop_rob_idx,
  input  [2:0]  io_req_bits_uop_ldq_idx,
  input  [2:0]  io_req_bits_uop_stq_idx,
  input  [5:0]  io_req_bits_uop_pdst,
  input  [5:0]  io_req_bits_uop_prs1,
  input         io_req_bits_uop_bypassable,
  input         io_req_bits_uop_is_amo,
  input         io_req_bits_uop_uses_stq,
  input  [1:0]  io_req_bits_uop_dst_rtype,
  input  [63:0] io_req_bits_rs1_data,
  input  [63:0] io_req_bits_rs2_data,
  input         io_req_bits_kill,
  output        io_resp_valid,
  output [2:0]  io_resp_bits_uop_ctrl_csr_cmd,
  output [19:0] io_resp_bits_uop_imm_packed,
  output [4:0]  io_resp_bits_uop_rob_idx,
  output [5:0]  io_resp_bits_uop_pdst,
  output        io_resp_bits_uop_bypassable,
  output        io_resp_bits_uop_is_amo,
  output        io_resp_bits_uop_uses_stq,
  output [1:0]  io_resp_bits_uop_dst_rtype,
  output [63:0] io_resp_bits_data,
  input  [7:0]  io_brupdate_b1_resolve_mask,
  input  [7:0]  io_brupdate_b1_mispredict_mask,
  output        io_bypass_0_valid,
  output [5:0]  io_bypass_0_bits_uop_pdst,
  output [1:0]  io_bypass_0_bits_uop_dst_rtype,
  output [63:0] io_bypass_0_bits_data,
  output        io_bypass_1_valid,
  output [5:0]  io_bypass_1_bits_uop_pdst,
  output [1:0]  io_bypass_1_bits_uop_dst_rtype,
  output [63:0] io_bypass_1_bits_data,
  output        io_bypass_2_valid,
  output [5:0]  io_bypass_2_bits_uop_pdst,
  output [1:0]  io_bypass_2_bits_uop_dst_rtype,
  output [63:0] io_bypass_2_bits_data,
  output        io_brinfo_uop_is_rvc,
  output [7:0]  io_brinfo_uop_br_mask,
  output [2:0]  io_brinfo_uop_br_tag,
  output [3:0]  io_brinfo_uop_ftq_idx,
  output        io_brinfo_uop_edge_inst,
  output [5:0]  io_brinfo_uop_pc_lob,
  output [4:0]  io_brinfo_uop_rob_idx,
  output [2:0]  io_brinfo_uop_ldq_idx,
  output [2:0]  io_brinfo_uop_stq_idx,
  output        io_brinfo_valid,
  output        io_brinfo_mispredict,
  output        io_brinfo_taken,
  output [2:0]  io_brinfo_cfi_type,
  output [1:0]  io_brinfo_pc_sel,
  output [39:0] io_brinfo_jalr_target,
  output [20:0] io_brinfo_target_offset,
  input         io_get_ftq_pc_entry_cfi_idx_valid,
  input  [1:0]  io_get_ftq_pc_entry_cfi_idx_bits,
  input         io_get_ftq_pc_entry_start_bank,
  input  [39:0] io_get_ftq_pc_pc,
  input         io_get_ftq_pc_next_val,
  input  [39:0] io_get_ftq_pc_next_pc
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [63:0] _RAND_32;
  reg [63:0] _RAND_33;
  reg [63:0] _RAND_34;
`endif // RANDOMIZE_REG_INIT
  wire  alu_io_dw; // @[functional-unit.scala 320:19]
  wire [3:0] alu_io_fn; // @[functional-unit.scala 320:19]
  wire [63:0] alu_io_in2; // @[functional-unit.scala 320:19]
  wire [63:0] alu_io_in1; // @[functional-unit.scala 320:19]
  wire [63:0] alu_io_out; // @[functional-unit.scala 320:19]
  wire [63:0] alu_io_adder_out; // @[functional-unit.scala 320:19]
  reg  r_valids_0; // @[functional-unit.scala 228:27]
  reg  r_valids_1; // @[functional-unit.scala 228:27]
  reg  r_valids_2; // @[functional-unit.scala 228:27]
  reg [2:0] r_uops_0_ctrl_csr_cmd; // @[functional-unit.scala 229:23]
  reg [7:0] r_uops_0_br_mask; // @[functional-unit.scala 229:23]
  reg [19:0] r_uops_0_imm_packed; // @[functional-unit.scala 229:23]
  reg [4:0] r_uops_0_rob_idx; // @[functional-unit.scala 229:23]
  reg [5:0] r_uops_0_pdst; // @[functional-unit.scala 229:23]
  reg  r_uops_0_bypassable; // @[functional-unit.scala 229:23]
  reg  r_uops_0_is_amo; // @[functional-unit.scala 229:23]
  reg  r_uops_0_uses_stq; // @[functional-unit.scala 229:23]
  reg [1:0] r_uops_0_dst_rtype; // @[functional-unit.scala 229:23]
  reg [2:0] r_uops_1_ctrl_csr_cmd; // @[functional-unit.scala 229:23]
  reg [7:0] r_uops_1_br_mask; // @[functional-unit.scala 229:23]
  reg [19:0] r_uops_1_imm_packed; // @[functional-unit.scala 229:23]
  reg [4:0] r_uops_1_rob_idx; // @[functional-unit.scala 229:23]
  reg [5:0] r_uops_1_pdst; // @[functional-unit.scala 229:23]
  reg  r_uops_1_bypassable; // @[functional-unit.scala 229:23]
  reg  r_uops_1_is_amo; // @[functional-unit.scala 229:23]
  reg  r_uops_1_uses_stq; // @[functional-unit.scala 229:23]
  reg [1:0] r_uops_1_dst_rtype; // @[functional-unit.scala 229:23]
  reg [2:0] r_uops_2_ctrl_csr_cmd; // @[functional-unit.scala 229:23]
  reg [7:0] r_uops_2_br_mask; // @[functional-unit.scala 229:23]
  reg [19:0] r_uops_2_imm_packed; // @[functional-unit.scala 229:23]
  reg [4:0] r_uops_2_rob_idx; // @[functional-unit.scala 229:23]
  reg [5:0] r_uops_2_pdst; // @[functional-unit.scala 229:23]
  reg  r_uops_2_bypassable; // @[functional-unit.scala 229:23]
  reg  r_uops_2_is_amo; // @[functional-unit.scala 229:23]
  reg  r_uops_2_uses_stq; // @[functional-unit.scala 229:23]
  reg [1:0] r_uops_2_dst_rtype; // @[functional-unit.scala 229:23]
  wire [7:0] _r_valids_0_T = io_brupdate_b1_mispredict_mask & io_req_bits_uop_br_mask; // @[util.scala 118:51]
  wire  _r_valids_0_T_1 = _r_valids_0_T != 8'h0; // @[util.scala 118:59]
  wire  _r_valids_0_T_4 = ~io_req_bits_kill; // @[functional-unit.scala 232:87]
  wire [7:0] _r_uops_0_br_mask_T = ~io_brupdate_b1_resolve_mask; // @[util.scala 85:27]
  wire [7:0] _r_valids_1_T = io_brupdate_b1_mispredict_mask & r_uops_0_br_mask; // @[util.scala 118:51]
  wire  _r_valids_1_T_1 = _r_valids_1_T != 8'h0; // @[util.scala 118:59]
  wire [7:0] _r_valids_2_T = io_brupdate_b1_mispredict_mask & r_uops_1_br_mask; // @[util.scala 118:51]
  wire  _r_valids_2_T_1 = _r_valids_2_T != 8'h0; // @[util.scala 118:59]
  wire [7:0] _io_resp_valid_T = io_brupdate_b1_mispredict_mask & r_uops_2_br_mask; // @[util.scala 118:51]
  wire  _io_resp_valid_T_1 = _io_resp_valid_T != 8'h0; // @[util.scala 118:59]
  wire  imm_xprlen_sign = io_req_bits_uop_imm_packed[19]; // @[util.scala 273:37]
  wire  _imm_xprlen_i30_20_T = io_req_bits_uop_ctrl_imm_sel == 3'h3; // @[util.scala 274:27]
  wire [10:0] _imm_xprlen_i30_20_T_2 = io_req_bits_uop_imm_packed[18:8]; // @[util.scala 274:46]
  wire  _imm_xprlen_i19_12_T_1 = io_req_bits_uop_ctrl_imm_sel == 3'h4; // @[util.scala 275:44]
  wire [7:0] _imm_xprlen_i19_12_T_4 = io_req_bits_uop_imm_packed[7:0]; // @[util.scala 275:62]
  wire  _imm_xprlen_i11_T_5 = io_req_bits_uop_imm_packed[8]; // @[util.scala 277:60]
  wire  _imm_xprlen_i11_T_6 = _imm_xprlen_i19_12_T_1 | io_req_bits_uop_ctrl_imm_sel == 3'h2 ? $signed(
    _imm_xprlen_i11_T_5) : $signed(imm_xprlen_sign); // @[util.scala 277:21]
  wire [4:0] _imm_xprlen_i10_5_T_2 = io_req_bits_uop_imm_packed[18:14]; // @[util.scala 278:52]
  wire [4:0] _imm_xprlen_i4_1_T_2 = io_req_bits_uop_imm_packed[13:9]; // @[util.scala 279:51]
  wire  imm_xprlen_lo_lo = io_req_bits_uop_ctrl_imm_sel == 3'h1 | io_req_bits_uop_ctrl_imm_sel == 3'h0 ? $signed(
    _imm_xprlen_i11_T_5) : $signed(1'sh0); // @[Cat.scala 31:58]
  wire [4:0] imm_xprlen_lo_hi_lo = _imm_xprlen_i30_20_T ? $signed(5'sh0) : $signed(_imm_xprlen_i4_1_T_2); // @[Cat.scala 31:58]
  wire [4:0] imm_xprlen_lo_hi_hi = _imm_xprlen_i30_20_T ? $signed(5'sh0) : $signed(_imm_xprlen_i10_5_T_2); // @[Cat.scala 31:58]
  wire  imm_xprlen_hi_lo_lo = _imm_xprlen_i30_20_T ? $signed(1'sh0) : $signed(_imm_xprlen_i11_T_6); // @[Cat.scala 31:58]
  wire [7:0] imm_xprlen_hi_lo_hi = _imm_xprlen_i30_20_T | io_req_bits_uop_ctrl_imm_sel == 3'h4 ? $signed(
    _imm_xprlen_i19_12_T_4) : $signed({8{imm_xprlen_sign}}); // @[Cat.scala 31:58]
  wire [10:0] imm_xprlen_hi_hi_lo = io_req_bits_uop_ctrl_imm_sel == 3'h3 ? $signed(_imm_xprlen_i30_20_T_2) : $signed({11
    {imm_xprlen_sign}}); // @[Cat.scala 31:58]
  wire  imm_xprlen_hi_hi_hi = io_req_bits_uop_imm_packed[19]; // @[Cat.scala 31:58]
  wire [31:0] imm_xprlen = {imm_xprlen_hi_hi_hi,imm_xprlen_hi_hi_lo,imm_xprlen_hi_lo_hi,imm_xprlen_hi_lo_lo,
    imm_xprlen_lo_hi_hi,imm_xprlen_lo_hi_lo,imm_xprlen_lo_lo}; // @[util.scala 282:60]
  wire [39:0] _block_pc_T = ~io_get_ftq_pc_pc; // @[util.scala 237:7]
  wire [39:0] _block_pc_T_1 = _block_pc_T | 40'h3f; // @[util.scala 237:11]
  wire [39:0] block_pc = ~_block_pc_T_1; // @[util.scala 237:5]
  wire [39:0] _GEN_5 = {{34'd0}, io_req_bits_uop_pc_lob}; // @[functional-unit.scala 303:28]
  wire [39:0] _uop_pc_T = block_pc | _GEN_5; // @[functional-unit.scala 303:28]
  wire [1:0] _uop_pc_T_1 = io_req_bits_uop_edge_inst ? 2'h2 : 2'h0; // @[functional-unit.scala 303:47]
  wire [39:0] _GEN_6 = {{38'd0}, _uop_pc_T_1}; // @[functional-unit.scala 303:42]
  wire [39:0] uop_pc = _uop_pc_T - _GEN_6; // @[functional-unit.scala 303:42]
  wire [23:0] _T_4 = uop_pc[39] ? 24'hffffff : 24'h0; // @[Bitwise.scala 74:12]
  wire [63:0] _T_5 = {_T_4,uop_pc}; // @[Cat.scala 31:58]
  wire [63:0] _T_6 = io_req_bits_uop_ctrl_op1_sel == 2'h2 ? _T_5 : 64'h0; // @[functional-unit.scala 306:19]
  wire [31:0] _op2_data_T_1 = {imm_xprlen_hi_hi_hi,imm_xprlen_hi_hi_lo,imm_xprlen_hi_lo_hi,imm_xprlen_hi_lo_lo,
    imm_xprlen_lo_hi_hi,imm_xprlen_lo_hi_lo,imm_xprlen_lo_lo}; // @[functional-unit.scala 314:69]
  wire [31:0] _op2_data_T_4 = _op2_data_T_1[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 74:12]
  wire [63:0] _op2_data_T_5 = {_op2_data_T_4,_op2_data_T_1}; // @[Cat.scala 31:58]
  wire [2:0] _op2_data_T_10 = io_req_bits_uop_is_rvc ? 3'h2 : 3'h4; // @[functional-unit.scala 317:56]
  wire [2:0] _op2_data_T_11 = io_req_bits_uop_ctrl_op2_sel == 3'h3 ? _op2_data_T_10 : 3'h0; // @[functional-unit.scala 317:21]
  wire [63:0] _op2_data_T_12 = io_req_bits_uop_ctrl_op2_sel == 3'h0 ? io_req_bits_rs2_data : {{61'd0}, _op2_data_T_11}; // @[functional-unit.scala 316:21]
  wire [63:0] _op2_data_T_13 = io_req_bits_uop_ctrl_op2_sel == 3'h4 ? {{59'd0}, io_req_bits_uop_prs1[4:0]} :
    _op2_data_T_12; // @[functional-unit.scala 315:21]
  wire  killed = io_req_bits_kill | _r_valids_0_T_1; // @[functional-unit.scala 331:26]
  wire  br_eq = io_req_bits_rs1_data == io_req_bits_rs2_data; // @[functional-unit.scala 337:21]
  wire  br_ltu = io_req_bits_rs1_data < io_req_bits_rs2_data; // @[functional-unit.scala 338:28]
  wire  _br_lt_T_8 = io_req_bits_rs1_data[63] & ~io_req_bits_rs2_data[63]; // @[functional-unit.scala 340:29]
  wire  br_lt = ~(io_req_bits_rs1_data[63] ^ io_req_bits_rs2_data[63]) & br_ltu | _br_lt_T_8; // @[functional-unit.scala 339:55]
  wire [1:0] _pc_sel_T_1 = ~br_eq ? 2'h1 : 2'h0; // @[functional-unit.scala 344:38]
  wire [1:0] _pc_sel_T_2 = br_eq ? 2'h1 : 2'h0; // @[functional-unit.scala 345:38]
  wire [1:0] _pc_sel_T_4 = ~br_lt ? 2'h1 : 2'h0; // @[functional-unit.scala 346:38]
  wire [1:0] _pc_sel_T_6 = ~br_ltu ? 2'h1 : 2'h0; // @[functional-unit.scala 347:38]
  wire [1:0] _pc_sel_T_7 = br_lt ? 2'h1 : 2'h0; // @[functional-unit.scala 348:38]
  wire [1:0] _pc_sel_T_8 = br_ltu ? 2'h1 : 2'h0; // @[functional-unit.scala 349:38]
  wire [1:0] _pc_sel_T_12 = 4'h1 == io_req_bits_uop_ctrl_br_type ? _pc_sel_T_1 : 2'h0; // @[Mux.scala 81:58]
  wire [1:0] _pc_sel_T_14 = 4'h2 == io_req_bits_uop_ctrl_br_type ? _pc_sel_T_2 : _pc_sel_T_12; // @[Mux.scala 81:58]
  wire [1:0] _pc_sel_T_16 = 4'h3 == io_req_bits_uop_ctrl_br_type ? _pc_sel_T_4 : _pc_sel_T_14; // @[Mux.scala 81:58]
  wire [1:0] _pc_sel_T_18 = 4'h4 == io_req_bits_uop_ctrl_br_type ? _pc_sel_T_6 : _pc_sel_T_16; // @[Mux.scala 81:58]
  wire [1:0] _pc_sel_T_20 = 4'h5 == io_req_bits_uop_ctrl_br_type ? _pc_sel_T_7 : _pc_sel_T_18; // @[Mux.scala 81:58]
  wire [1:0] _pc_sel_T_22 = 4'h6 == io_req_bits_uop_ctrl_br_type ? _pc_sel_T_8 : _pc_sel_T_20; // @[Mux.scala 81:58]
  wire [1:0] _pc_sel_T_24 = 4'h7 == io_req_bits_uop_ctrl_br_type ? 2'h1 : _pc_sel_T_22; // @[Mux.scala 81:58]
  wire [1:0] pc_sel = 4'h8 == io_req_bits_uop_ctrl_br_type ? 2'h2 : _pc_sel_T_24; // @[Mux.scala 81:58]
  wire  _is_taken_T = ~killed; // @[functional-unit.scala 355:20]
  wire  _is_taken_T_1 = io_req_valid & _is_taken_T; // @[functional-unit.scala 354:31]
  wire  _is_taken_T_3 = io_req_bits_uop_is_br | io_req_bits_uop_is_jalr | io_req_bits_uop_is_jal; // @[functional-unit.scala 356:46]
  wire  _is_taken_T_4 = _is_taken_T_1 & _is_taken_T_3; // @[functional-unit.scala 355:28]
  wire  _is_taken_T_5 = pc_sel != 2'h0; // @[functional-unit.scala 357:28]
  wire  is_br = _is_taken_T_1 & io_req_bits_uop_is_br & ~io_req_bits_uop_is_sfb; // @[functional-unit.scala 362:61]
  wire  is_jalr = _is_taken_T_1 & io_req_bits_uop_is_jalr; // @[functional-unit.scala 364:48]
  wire  _GEN_1 = pc_sel == 2'h0 & io_req_bits_uop_taken; // @[functional-unit.scala 370:32 371:18]
  wire  _GEN_2 = pc_sel == 2'h1 ? ~io_req_bits_uop_taken : _GEN_1; // @[functional-unit.scala 373:32 374:18]
  wire  _GEN_3 = (is_br | is_jalr) & _GEN_2; // @[functional-unit.scala 366:27]
  wire [2:0] _brinfo_cfi_type_T = is_br ? 3'h1 : 3'h0; // @[functional-unit.scala 385:31]
  wire [20:0] target_offset = imm_xprlen[20:0]; // @[functional-unit.scala 395:40]
  wire [63:0] _GEN_7 = {{43{target_offset[20]}},target_offset}; // @[functional-unit.scala 411:43]
  wire [63:0] jalr_target_xlen = $signed(io_req_bits_rs1_data) + $signed(_GEN_7); // @[functional-unit.scala 411:60]
  wire [63:0] _jalr_target_a_T = $signed(io_req_bits_rs1_data) + $signed(_GEN_7); // @[functional-unit.scala 403:18]
  wire [24:0] a = _jalr_target_a_T[63:39]; // @[functional-unit.scala 403:25]
  wire  msb = $signed(a) == 25'sh0 | $signed(a) == -25'sh1 ? jalr_target_xlen[39] : ~jalr_target_xlen[38]; // @[functional-unit.scala 404:20]
  wire [39:0] _jalr_target_T_2 = {msb,jalr_target_xlen[38:0]}; // @[functional-unit.scala 412:81]
  wire [39:0] jalr_target = $signed(_jalr_target_T_2) & -40'sh2; // @[functional-unit.scala 412:96]
  wire [3:0] _cfi_idx_T_2 = io_get_ftq_pc_entry_start_bank ? 4'h8 : 4'h0; // @[functional-unit.scala 415:37]
  wire [5:0] _GEN_8 = {{2'd0}, _cfi_idx_T_2}; // @[functional-unit.scala 415:32]
  wire [5:0] _cfi_idx_T_3 = io_req_bits_uop_pc_lob ^ _GEN_8; // @[functional-unit.scala 415:32]
  wire [1:0] cfi_idx = _cfi_idx_T_3[2:1]; // @[functional-unit.scala 415:112]
  wire  _mispredict_T_2 = io_get_ftq_pc_next_pc != jalr_target; // @[functional-unit.scala 419:44]
  wire  _mispredict_T_3 = ~io_get_ftq_pc_next_val | _mispredict_T_2; // @[functional-unit.scala 418:45]
  wire  _mispredict_T_4 = ~io_get_ftq_pc_entry_cfi_idx_valid; // @[functional-unit.scala 420:21]
  wire  _mispredict_T_5 = _mispredict_T_3 | _mispredict_T_4; // @[functional-unit.scala 419:61]
  wire  _mispredict_T_6 = io_get_ftq_pc_entry_cfi_idx_bits != cfi_idx; // @[functional-unit.scala 421:55]
  wire  _mispredict_T_7 = _mispredict_T_5 | _mispredict_T_6; // @[functional-unit.scala 420:56]
  reg  r_val_0; // @[functional-unit.scala 439:23]
  reg  r_val_1; // @[functional-unit.scala 439:23]
  reg [63:0] r_data_0; // @[functional-unit.scala 440:19]
  reg [63:0] r_data_1; // @[functional-unit.scala 440:19]
  reg [63:0] r_data_2; // @[functional-unit.scala 440:19]
  ALU alu ( // @[functional-unit.scala 320:19]
    .io_dw(alu_io_dw),
    .io_fn(alu_io_fn),
    .io_in2(alu_io_in2),
    .io_in1(alu_io_in1),
    .io_out(alu_io_out),
    .io_adder_out(alu_io_adder_out)
  );
  assign io_resp_valid = r_valids_2 & ~_io_resp_valid_T_1; // @[functional-unit.scala 249:47]
  assign io_resp_bits_uop_ctrl_csr_cmd = r_uops_2_ctrl_csr_cmd; // @[functional-unit.scala 251:22]
  assign io_resp_bits_uop_imm_packed = r_uops_2_imm_packed; // @[functional-unit.scala 251:22]
  assign io_resp_bits_uop_rob_idx = r_uops_2_rob_idx; // @[functional-unit.scala 251:22]
  assign io_resp_bits_uop_pdst = r_uops_2_pdst; // @[functional-unit.scala 251:22]
  assign io_resp_bits_uop_bypassable = r_uops_2_bypassable; // @[functional-unit.scala 251:22]
  assign io_resp_bits_uop_is_amo = r_uops_2_is_amo; // @[functional-unit.scala 251:22]
  assign io_resp_bits_uop_uses_stq = r_uops_2_uses_stq; // @[functional-unit.scala 251:22]
  assign io_resp_bits_uop_dst_rtype = r_uops_2_dst_rtype; // @[functional-unit.scala 251:22]
  assign io_resp_bits_data = r_data_2; // @[functional-unit.scala 453:21]
  assign io_bypass_0_valid = io_req_valid; // @[functional-unit.scala 459:22]
  assign io_bypass_0_bits_uop_pdst = io_req_bits_uop_pdst; // @[functional-unit.scala 256:29]
  assign io_bypass_0_bits_uop_dst_rtype = io_req_bits_uop_dst_rtype; // @[functional-unit.scala 256:29]
  assign io_bypass_0_bits_data = io_req_bits_uop_uopc == 7'h6d ? io_req_bits_rs2_data : alu_io_out; // @[functional-unit.scala 444:8]
  assign io_bypass_1_valid = r_val_0; // @[functional-unit.scala 462:24]
  assign io_bypass_1_bits_uop_pdst = r_uops_0_pdst; // @[functional-unit.scala 259:31]
  assign io_bypass_1_bits_uop_dst_rtype = r_uops_0_dst_rtype; // @[functional-unit.scala 259:31]
  assign io_bypass_1_bits_data = r_data_0; // @[functional-unit.scala 463:28]
  assign io_bypass_2_valid = r_val_1; // @[functional-unit.scala 462:24]
  assign io_bypass_2_bits_uop_pdst = r_uops_1_pdst; // @[functional-unit.scala 259:31]
  assign io_bypass_2_bits_uop_dst_rtype = r_uops_1_dst_rtype; // @[functional-unit.scala 259:31]
  assign io_bypass_2_bits_data = r_data_1; // @[functional-unit.scala 463:28]
  assign io_brinfo_uop_is_rvc = io_req_bits_uop_is_rvc; // @[functional-unit.scala 378:20 383:25]
  assign io_brinfo_uop_br_mask = io_req_bits_uop_br_mask; // @[functional-unit.scala 378:20 383:25]
  assign io_brinfo_uop_br_tag = io_req_bits_uop_br_tag; // @[functional-unit.scala 378:20 383:25]
  assign io_brinfo_uop_ftq_idx = io_req_bits_uop_ftq_idx; // @[functional-unit.scala 378:20 383:25]
  assign io_brinfo_uop_edge_inst = io_req_bits_uop_edge_inst; // @[functional-unit.scala 378:20 383:25]
  assign io_brinfo_uop_pc_lob = io_req_bits_uop_pc_lob; // @[functional-unit.scala 378:20 383:25]
  assign io_brinfo_uop_rob_idx = io_req_bits_uop_rob_idx; // @[functional-unit.scala 378:20 383:25]
  assign io_brinfo_uop_ldq_idx = io_req_bits_uop_ldq_idx; // @[functional-unit.scala 378:20 383:25]
  assign io_brinfo_uop_stq_idx = io_req_bits_uop_stq_idx; // @[functional-unit.scala 378:20 383:25]
  assign io_brinfo_valid = is_br | is_jalr; // @[functional-unit.scala 381:34]
  assign io_brinfo_mispredict = pc_sel == 2'h2 ? _mispredict_T_7 : _GEN_3; // @[functional-unit.scala 417:31 418:18]
  assign io_brinfo_taken = _is_taken_T_4 & _is_taken_T_5; // @[functional-unit.scala 356:61]
  assign io_brinfo_cfi_type = is_jalr ? 3'h3 : _brinfo_cfi_type_T; // @[functional-unit.scala 384:31]
  assign io_brinfo_pc_sel = 4'h8 == io_req_bits_uop_ctrl_br_type ? 2'h2 : _pc_sel_T_24; // @[Mux.scala 81:58]
  assign io_brinfo_jalr_target = $signed(_jalr_target_T_2) & -40'sh2; // @[functional-unit.scala 412:96]
  assign io_brinfo_target_offset = imm_xprlen[20:0]; // @[functional-unit.scala 395:40]
  assign alu_io_dw = io_req_bits_uop_ctrl_fcn_dw; // @[functional-unit.scala 325:14]
  assign alu_io_fn = io_req_bits_uop_ctrl_op_fcn; // @[functional-unit.scala 324:14]
  assign alu_io_in2 = io_req_bits_uop_ctrl_op2_sel == 3'h1 ? _op2_data_T_5 : _op2_data_T_13; // @[functional-unit.scala 314:21]
  assign alu_io_in1 = io_req_bits_uop_ctrl_op1_sel == 2'h0 ? io_req_bits_rs1_data : _T_6; // @[functional-unit.scala 305:19]
  always @(posedge clock) begin
    if (reset) begin // @[functional-unit.scala 228:27]
      r_valids_0 <= 1'h0; // @[functional-unit.scala 228:27]
    end else begin
      r_valids_0 <= io_req_valid & ~_r_valids_0_T_1 & ~io_req_bits_kill; // @[functional-unit.scala 232:17]
    end
    if (reset) begin // @[functional-unit.scala 228:27]
      r_valids_1 <= 1'h0; // @[functional-unit.scala 228:27]
    end else begin
      r_valids_1 <= r_valids_0 & ~_r_valids_1_T_1 & _r_valids_0_T_4; // @[functional-unit.scala 238:19]
    end
    if (reset) begin // @[functional-unit.scala 228:27]
      r_valids_2 <= 1'h0; // @[functional-unit.scala 228:27]
    end else begin
      r_valids_2 <= r_valids_1 & ~_r_valids_2_T_1 & _r_valids_0_T_4; // @[functional-unit.scala 238:19]
    end
    r_uops_0_ctrl_csr_cmd <= io_req_bits_uop_ctrl_csr_cmd; // @[functional-unit.scala 233:17]
    r_uops_0_br_mask <= io_req_bits_uop_br_mask & _r_uops_0_br_mask_T; // @[util.scala 85:25]
    r_uops_0_imm_packed <= io_req_bits_uop_imm_packed; // @[functional-unit.scala 233:17]
    r_uops_0_rob_idx <= io_req_bits_uop_rob_idx; // @[functional-unit.scala 233:17]
    r_uops_0_pdst <= io_req_bits_uop_pdst; // @[functional-unit.scala 233:17]
    r_uops_0_bypassable <= io_req_bits_uop_bypassable; // @[functional-unit.scala 233:17]
    r_uops_0_is_amo <= io_req_bits_uop_is_amo; // @[functional-unit.scala 233:17]
    r_uops_0_uses_stq <= io_req_bits_uop_uses_stq; // @[functional-unit.scala 233:17]
    r_uops_0_dst_rtype <= io_req_bits_uop_dst_rtype; // @[functional-unit.scala 233:17]
    r_uops_1_ctrl_csr_cmd <= r_uops_0_ctrl_csr_cmd; // @[functional-unit.scala 239:19]
    r_uops_1_br_mask <= r_uops_0_br_mask & _r_uops_0_br_mask_T; // @[util.scala 85:25]
    r_uops_1_imm_packed <= r_uops_0_imm_packed; // @[functional-unit.scala 239:19]
    r_uops_1_rob_idx <= r_uops_0_rob_idx; // @[functional-unit.scala 239:19]
    r_uops_1_pdst <= r_uops_0_pdst; // @[functional-unit.scala 239:19]
    r_uops_1_bypassable <= r_uops_0_bypassable; // @[functional-unit.scala 239:19]
    r_uops_1_is_amo <= r_uops_0_is_amo; // @[functional-unit.scala 239:19]
    r_uops_1_uses_stq <= r_uops_0_uses_stq; // @[functional-unit.scala 239:19]
    r_uops_1_dst_rtype <= r_uops_0_dst_rtype; // @[functional-unit.scala 239:19]
    r_uops_2_ctrl_csr_cmd <= r_uops_1_ctrl_csr_cmd; // @[functional-unit.scala 239:19]
    r_uops_2_br_mask <= r_uops_1_br_mask & _r_uops_0_br_mask_T; // @[util.scala 85:25]
    r_uops_2_imm_packed <= r_uops_1_imm_packed; // @[functional-unit.scala 239:19]
    r_uops_2_rob_idx <= r_uops_1_rob_idx; // @[functional-unit.scala 239:19]
    r_uops_2_pdst <= r_uops_1_pdst; // @[functional-unit.scala 239:19]
    r_uops_2_bypassable <= r_uops_1_bypassable; // @[functional-unit.scala 239:19]
    r_uops_2_is_amo <= r_uops_1_is_amo; // @[functional-unit.scala 239:19]
    r_uops_2_uses_stq <= r_uops_1_uses_stq; // @[functional-unit.scala 239:19]
    r_uops_2_dst_rtype <= r_uops_1_dst_rtype; // @[functional-unit.scala 239:19]
    if (reset) begin // @[functional-unit.scala 439:23]
      r_val_0 <= 1'h0; // @[functional-unit.scala 439:23]
    end else begin
      r_val_0 <= io_req_valid; // @[functional-unit.scala 445:13]
    end
    if (reset) begin // @[functional-unit.scala 439:23]
      r_val_1 <= 1'h0; // @[functional-unit.scala 439:23]
    end else begin
      r_val_1 <= r_val_0; // @[functional-unit.scala 449:15]
    end
    if (io_req_bits_uop_uopc == 7'h6d) begin // @[functional-unit.scala 444:8]
      r_data_0 <= io_req_bits_rs2_data;
    end else begin
      r_data_0 <= alu_io_out;
    end
    r_data_1 <= r_data_0; // @[functional-unit.scala 450:15]
    r_data_2 <= r_data_1; // @[functional-unit.scala 450:15]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  r_valids_0 = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  r_valids_1 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  r_valids_2 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  r_uops_0_ctrl_csr_cmd = _RAND_3[2:0];
  _RAND_4 = {1{`RANDOM}};
  r_uops_0_br_mask = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  r_uops_0_imm_packed = _RAND_5[19:0];
  _RAND_6 = {1{`RANDOM}};
  r_uops_0_rob_idx = _RAND_6[4:0];
  _RAND_7 = {1{`RANDOM}};
  r_uops_0_pdst = _RAND_7[5:0];
  _RAND_8 = {1{`RANDOM}};
  r_uops_0_bypassable = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  r_uops_0_is_amo = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  r_uops_0_uses_stq = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  r_uops_0_dst_rtype = _RAND_11[1:0];
  _RAND_12 = {1{`RANDOM}};
  r_uops_1_ctrl_csr_cmd = _RAND_12[2:0];
  _RAND_13 = {1{`RANDOM}};
  r_uops_1_br_mask = _RAND_13[7:0];
  _RAND_14 = {1{`RANDOM}};
  r_uops_1_imm_packed = _RAND_14[19:0];
  _RAND_15 = {1{`RANDOM}};
  r_uops_1_rob_idx = _RAND_15[4:0];
  _RAND_16 = {1{`RANDOM}};
  r_uops_1_pdst = _RAND_16[5:0];
  _RAND_17 = {1{`RANDOM}};
  r_uops_1_bypassable = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  r_uops_1_is_amo = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  r_uops_1_uses_stq = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  r_uops_1_dst_rtype = _RAND_20[1:0];
  _RAND_21 = {1{`RANDOM}};
  r_uops_2_ctrl_csr_cmd = _RAND_21[2:0];
  _RAND_22 = {1{`RANDOM}};
  r_uops_2_br_mask = _RAND_22[7:0];
  _RAND_23 = {1{`RANDOM}};
  r_uops_2_imm_packed = _RAND_23[19:0];
  _RAND_24 = {1{`RANDOM}};
  r_uops_2_rob_idx = _RAND_24[4:0];
  _RAND_25 = {1{`RANDOM}};
  r_uops_2_pdst = _RAND_25[5:0];
  _RAND_26 = {1{`RANDOM}};
  r_uops_2_bypassable = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  r_uops_2_is_amo = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  r_uops_2_uses_stq = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  r_uops_2_dst_rtype = _RAND_29[1:0];
  _RAND_30 = {1{`RANDOM}};
  r_val_0 = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  r_val_1 = _RAND_31[0:0];
  _RAND_32 = {2{`RANDOM}};
  r_data_0 = _RAND_32[63:0];
  _RAND_33 = {2{`RANDOM}};
  r_data_1 = _RAND_33[63:0];
  _RAND_34 = {2{`RANDOM}};
  r_data_2 = _RAND_34[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ALU(
  input         io_dw,
  input  [3:0]  io_fn,
  input  [63:0] io_in2,
  input  [63:0] io_in1,
  output [63:0] io_out,
  output [63:0] io_adder_out
);
  wire [63:0] _in2_inv_T_1 = ~io_in2; // @[ALU.scala 62:35]
  wire [63:0] in2_inv = io_fn[3] ? _in2_inv_T_1 : io_in2; // @[ALU.scala 62:20]
  wire [63:0] in1_xor_in2 = io_in1 ^ in2_inv; // @[ALU.scala 63:28]
  wire [63:0] _io_adder_out_T_1 = io_in1 + in2_inv; // @[ALU.scala 64:26]
  wire [63:0] _GEN_1 = {{63'd0}, io_fn[3]}; // @[ALU.scala 64:36]
  wire  _slt_T_7 = io_fn[1] ? io_in2[63] : io_in1[63]; // @[ALU.scala 69:8]
  wire  slt = io_in1[63] == io_in2[63] ? io_adder_out[63] : _slt_T_7; // @[ALU.scala 68:8]
  wire  _T_2 = io_fn[3] & io_in1[31]; // @[ALU.scala 77:46]
  wire [31:0] _T_4 = _T_2 ? 32'hffffffff : 32'h0; // @[Bitwise.scala 74:12]
  wire [31:0] _T_7 = io_dw ? io_in1[63:32] : _T_4; // @[ALU.scala 78:24]
  wire  _T_10 = io_in2[5] & io_dw; // @[ALU.scala 79:33]
  wire [5:0] shamt = {_T_10,io_in2[4:0]}; // @[Cat.scala 31:58]
  wire [63:0] shin_r = {_T_7,io_in1[31:0]}; // @[Cat.scala 31:58]
  wire  _shin_T_2 = io_fn == 4'h5 | io_fn == 4'hb; // @[ALU.scala 82:35]
  wire [63:0] _GEN_2 = {{32'd0}, shin_r[63:32]}; // @[Bitwise.scala 105:31]
  wire [63:0] _shin_T_6 = _GEN_2 & 64'hffffffff; // @[Bitwise.scala 105:31]
  wire [63:0] _shin_T_8 = {shin_r[31:0], 32'h0}; // @[Bitwise.scala 105:70]
  wire [63:0] _shin_T_10 = _shin_T_8 & 64'hffffffff00000000; // @[Bitwise.scala 105:80]
  wire [63:0] _shin_T_11 = _shin_T_6 | _shin_T_10; // @[Bitwise.scala 105:39]
  wire [63:0] _GEN_3 = {{16'd0}, _shin_T_11[63:16]}; // @[Bitwise.scala 105:31]
  wire [63:0] _shin_T_16 = _GEN_3 & 64'hffff0000ffff; // @[Bitwise.scala 105:31]
  wire [63:0] _shin_T_18 = {_shin_T_11[47:0], 16'h0}; // @[Bitwise.scala 105:70]
  wire [63:0] _shin_T_20 = _shin_T_18 & 64'hffff0000ffff0000; // @[Bitwise.scala 105:80]
  wire [63:0] _shin_T_21 = _shin_T_16 | _shin_T_20; // @[Bitwise.scala 105:39]
  wire [63:0] _GEN_4 = {{8'd0}, _shin_T_21[63:8]}; // @[Bitwise.scala 105:31]
  wire [63:0] _shin_T_26 = _GEN_4 & 64'hff00ff00ff00ff; // @[Bitwise.scala 105:31]
  wire [63:0] _shin_T_28 = {_shin_T_21[55:0], 8'h0}; // @[Bitwise.scala 105:70]
  wire [63:0] _shin_T_30 = _shin_T_28 & 64'hff00ff00ff00ff00; // @[Bitwise.scala 105:80]
  wire [63:0] _shin_T_31 = _shin_T_26 | _shin_T_30; // @[Bitwise.scala 105:39]
  wire [63:0] _GEN_5 = {{4'd0}, _shin_T_31[63:4]}; // @[Bitwise.scala 105:31]
  wire [63:0] _shin_T_36 = _GEN_5 & 64'hf0f0f0f0f0f0f0f; // @[Bitwise.scala 105:31]
  wire [63:0] _shin_T_38 = {_shin_T_31[59:0], 4'h0}; // @[Bitwise.scala 105:70]
  wire [63:0] _shin_T_40 = _shin_T_38 & 64'hf0f0f0f0f0f0f0f0; // @[Bitwise.scala 105:80]
  wire [63:0] _shin_T_41 = _shin_T_36 | _shin_T_40; // @[Bitwise.scala 105:39]
  wire [63:0] _GEN_6 = {{2'd0}, _shin_T_41[63:2]}; // @[Bitwise.scala 105:31]
  wire [63:0] _shin_T_46 = _GEN_6 & 64'h3333333333333333; // @[Bitwise.scala 105:31]
  wire [63:0] _shin_T_48 = {_shin_T_41[61:0], 2'h0}; // @[Bitwise.scala 105:70]
  wire [63:0] _shin_T_50 = _shin_T_48 & 64'hcccccccccccccccc; // @[Bitwise.scala 105:80]
  wire [63:0] _shin_T_51 = _shin_T_46 | _shin_T_50; // @[Bitwise.scala 105:39]
  wire [63:0] _GEN_7 = {{1'd0}, _shin_T_51[63:1]}; // @[Bitwise.scala 105:31]
  wire [63:0] _shin_T_56 = _GEN_7 & 64'h5555555555555555; // @[Bitwise.scala 105:31]
  wire [63:0] _shin_T_58 = {_shin_T_51[62:0], 1'h0}; // @[Bitwise.scala 105:70]
  wire [63:0] _shin_T_60 = _shin_T_58 & 64'haaaaaaaaaaaaaaaa; // @[Bitwise.scala 105:80]
  wire [63:0] _shin_T_61 = _shin_T_56 | _shin_T_60; // @[Bitwise.scala 105:39]
  wire [63:0] shin = io_fn == 4'h5 | io_fn == 4'hb ? shin_r : _shin_T_61; // @[ALU.scala 82:17]
  wire  _shout_r_T_2 = io_fn[3] & shin[63]; // @[ALU.scala 83:35]
  wire [64:0] _shout_r_T_4 = {_shout_r_T_2,shin}; // @[ALU.scala 83:57]
  wire [64:0] _shout_r_T_5 = $signed(_shout_r_T_4) >>> shamt; // @[ALU.scala 83:64]
  wire [63:0] shout_r = _shout_r_T_5[63:0]; // @[ALU.scala 83:73]
  wire [63:0] _GEN_8 = {{32'd0}, shout_r[63:32]}; // @[Bitwise.scala 105:31]
  wire [63:0] _shout_l_T_3 = _GEN_8 & 64'hffffffff; // @[Bitwise.scala 105:31]
  wire [63:0] _shout_l_T_5 = {shout_r[31:0], 32'h0}; // @[Bitwise.scala 105:70]
  wire [63:0] _shout_l_T_7 = _shout_l_T_5 & 64'hffffffff00000000; // @[Bitwise.scala 105:80]
  wire [63:0] _shout_l_T_8 = _shout_l_T_3 | _shout_l_T_7; // @[Bitwise.scala 105:39]
  wire [63:0] _GEN_9 = {{16'd0}, _shout_l_T_8[63:16]}; // @[Bitwise.scala 105:31]
  wire [63:0] _shout_l_T_13 = _GEN_9 & 64'hffff0000ffff; // @[Bitwise.scala 105:31]
  wire [63:0] _shout_l_T_15 = {_shout_l_T_8[47:0], 16'h0}; // @[Bitwise.scala 105:70]
  wire [63:0] _shout_l_T_17 = _shout_l_T_15 & 64'hffff0000ffff0000; // @[Bitwise.scala 105:80]
  wire [63:0] _shout_l_T_18 = _shout_l_T_13 | _shout_l_T_17; // @[Bitwise.scala 105:39]
  wire [63:0] _GEN_10 = {{8'd0}, _shout_l_T_18[63:8]}; // @[Bitwise.scala 105:31]
  wire [63:0] _shout_l_T_23 = _GEN_10 & 64'hff00ff00ff00ff; // @[Bitwise.scala 105:31]
  wire [63:0] _shout_l_T_25 = {_shout_l_T_18[55:0], 8'h0}; // @[Bitwise.scala 105:70]
  wire [63:0] _shout_l_T_27 = _shout_l_T_25 & 64'hff00ff00ff00ff00; // @[Bitwise.scala 105:80]
  wire [63:0] _shout_l_T_28 = _shout_l_T_23 | _shout_l_T_27; // @[Bitwise.scala 105:39]
  wire [63:0] _GEN_11 = {{4'd0}, _shout_l_T_28[63:4]}; // @[Bitwise.scala 105:31]
  wire [63:0] _shout_l_T_33 = _GEN_11 & 64'hf0f0f0f0f0f0f0f; // @[Bitwise.scala 105:31]
  wire [63:0] _shout_l_T_35 = {_shout_l_T_28[59:0], 4'h0}; // @[Bitwise.scala 105:70]
  wire [63:0] _shout_l_T_37 = _shout_l_T_35 & 64'hf0f0f0f0f0f0f0f0; // @[Bitwise.scala 105:80]
  wire [63:0] _shout_l_T_38 = _shout_l_T_33 | _shout_l_T_37; // @[Bitwise.scala 105:39]
  wire [63:0] _GEN_12 = {{2'd0}, _shout_l_T_38[63:2]}; // @[Bitwise.scala 105:31]
  wire [63:0] _shout_l_T_43 = _GEN_12 & 64'h3333333333333333; // @[Bitwise.scala 105:31]
  wire [63:0] _shout_l_T_45 = {_shout_l_T_38[61:0], 2'h0}; // @[Bitwise.scala 105:70]
  wire [63:0] _shout_l_T_47 = _shout_l_T_45 & 64'hcccccccccccccccc; // @[Bitwise.scala 105:80]
  wire [63:0] _shout_l_T_48 = _shout_l_T_43 | _shout_l_T_47; // @[Bitwise.scala 105:39]
  wire [63:0] _GEN_13 = {{1'd0}, _shout_l_T_48[63:1]}; // @[Bitwise.scala 105:31]
  wire [63:0] _shout_l_T_53 = _GEN_13 & 64'h5555555555555555; // @[Bitwise.scala 105:31]
  wire [63:0] _shout_l_T_55 = {_shout_l_T_48[62:0], 1'h0}; // @[Bitwise.scala 105:70]
  wire [63:0] _shout_l_T_57 = _shout_l_T_55 & 64'haaaaaaaaaaaaaaaa; // @[Bitwise.scala 105:80]
  wire [63:0] shout_l = _shout_l_T_53 | _shout_l_T_57; // @[Bitwise.scala 105:39]
  wire [63:0] _shout_T_3 = _shin_T_2 ? shout_r : 64'h0; // @[ALU.scala 85:18]
  wire [63:0] _shout_T_5 = io_fn == 4'h1 ? shout_l : 64'h0; // @[ALU.scala 86:18]
  wire [63:0] shout = _shout_T_3 | _shout_T_5; // @[ALU.scala 85:70]
  wire  _logic_T_1 = io_fn == 4'h6; // @[ALU.scala 89:45]
  wire [63:0] _logic_T_3 = io_fn == 4'h4 | io_fn == 4'h6 ? in1_xor_in2 : 64'h0; // @[ALU.scala 89:18]
  wire [63:0] _logic_T_7 = io_in1 & io_in2; // @[ALU.scala 90:63]
  wire [63:0] _logic_T_8 = _logic_T_1 | io_fn == 4'h7 ? _logic_T_7 : 64'h0; // @[ALU.scala 90:18]
  wire [63:0] logic_ = _logic_T_3 | _logic_T_8; // @[ALU.scala 89:74]
  wire  _shift_logic_T = io_fn >= 4'hc; // @[ALU.scala 42:30]
  wire  _shift_logic_T_1 = _shift_logic_T & slt; // @[ALU.scala 91:35]
  wire [63:0] _GEN_14 = {{63'd0}, _shift_logic_T_1}; // @[ALU.scala 91:43]
  wire [63:0] _shift_logic_T_2 = _GEN_14 | logic_; // @[ALU.scala 91:43]
  wire [63:0] shift_logic = _shift_logic_T_2 | shout; // @[ALU.scala 91:51]
  wire [63:0] out = io_fn == 4'h0 | io_fn == 4'ha ? io_adder_out : shift_logic; // @[ALU.scala 92:16]
  wire [31:0] _io_out_T_2 = out[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 74:12]
  wire [63:0] _io_out_T_4 = {_io_out_T_2,out[31:0]}; // @[Cat.scala 31:58]
  assign io_out = ~io_dw ? _io_out_T_4 : out; // @[ALU.scala 94:10 97:{28,37}]
  assign io_adder_out = _io_adder_out_T_1 + _GEN_1; // @[ALU.scala 64:36]
endmodule