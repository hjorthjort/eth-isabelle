theory "InstructionPc" 

imports 
   "InstructionAux" "../ProgramInAvl"

begin

fun is_inc_pc :: "inst option \<Rightarrow> bool" where
  "is_inc_pc (Some (Pc JUMP)) = False"
| "is_inc_pc (Some (Pc JUMPI)) = False"
| "is_inc_pc (Some (Stack (PUSH_N _))) = False"
| "is_inc_pc (Some (Unknown _)) = False"
| "is_inc_pc _ = True"

theorem inc_pc_one [simp] :
   "is_inc_pc (Some inst) \<Longrightarrow> inst_size inst = 1"
apply(induction "Some inst" rule:is_inc_pc.induct)
apply(auto)
done

declare vctx_advance_pc_def [simp del]
declare inst_size_def [simp del]

theorem lemma_advance [simp] :
  "is_inc_pc (vctx_next_instruction v c) \<Longrightarrow>
   vctx_pc (vctx_advance_pc c v) = vctx_pc v + 1"
apply(auto simp:vctx_advance_pc_def)
apply(cases " vctx_next_instruction v c")
apply(auto)
done

declare stack_1_1_op_def [simp del]

theorem lemma_stack_op_2_1 [simp] :
 "stack_2_1_op v c fn = InstructionContinue nv \<Longrightarrow>
  is_inc_pc (vctx_next_instruction v c) \<Longrightarrow>
  vctx_pc nv = vctx_pc v + 1"
apply(simp add:stack_2_1_op_def)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "tl (vctx_stack v)")
apply(auto)
done

theorem lemma_stack_op_1_1 [simp] :
 "stack_1_1_op v c fn = InstructionContinue nv \<Longrightarrow>
  is_inc_pc (vctx_next_instruction v c) \<Longrightarrow>
  vctx_pc nv = vctx_pc v + 1"
apply(simp add:stack_1_1_op_def)
apply(cases "vctx_stack v")
apply(auto)
done

theorem lemma_stack_op_3_1 [simp] :
 "stack_3_1_op v c fn = InstructionContinue nv \<Longrightarrow>
  is_inc_pc (vctx_next_instruction v c) \<Longrightarrow>
  vctx_pc nv = vctx_pc v + 1"
apply(simp add:stack_3_1_op_def)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "tl (vctx_stack v)")
apply(auto)
apply(cases "tl (tl (vctx_stack v))")
apply(auto)
done

theorem lemma_pop_stack [simp] :
   "vctx_pc (vctx_pop_stack x v) = vctx_pc v"
apply auto
done

theorem lemma_log [simp] :
 "Evm.log x v c = InstructionContinue nv \<Longrightarrow>
  is_inc_pc (vctx_next_instruction v c) \<Longrightarrow>
  vctx_pc nv = vctx_pc v + 1"
apply(auto simp:log_def split:option.split)
done

declare vctx_next_instruction_def [simp del]


theorem no_jump_inc_pc_aux :
  "instruction_aux v c inst = InstructionContinue nv \<Longrightarrow>
   vctx_next_instruction v c = Some inst \<Longrightarrow>
   is_inc_pc (vctx_next_instruction v c) \<Longrightarrow>
   vctx_pc nv = vctx_pc v + 1"
apply(auto)
apply(cases "vctx_next_instruction v c")
apply(auto)

apply(cases "inst")
apply (auto simp:instruction_aux_def)
apply(cases "get_bits (Some inst)")
apply(auto)
apply(cases "get_sarith (Some inst)")
apply(auto)
apply(cases "get_arith (Some inst)")
apply(auto)
apply(cases "vctx_stack v")
apply(auto simp:sha3_def)
apply(cases "tl (vctx_stack v)")
apply(auto)
apply(cases "get_info (Some inst)")
apply(auto)
apply(cases "index (vctx_stack v)
              (nat (uint (get_dup (Some inst))))")
apply(auto)
apply(cases "get_memory (Some inst)")
apply(auto)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "tl (vctx_stack v)")
apply(simp)
apply(simp)
apply(auto)
apply(cases "vctx_stack v")
apply(simp)
apply(cases "tl (vctx_stack v)")
apply(auto)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "tl (vctx_stack v)")
apply(auto)
apply(cases "tl (tl (vctx_stack v))")
apply(auto)
(* apply(simp add:codecopy_def) *)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "tl (vctx_stack v)")
apply(auto)
apply(cases "tl (tl (vctx_stack v))")
apply(auto)
(* apply(simp add:extcodecopy_def) *)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "tl (vctx_stack v)")
apply(auto)
apply(cases "tl (tl (vctx_stack v))")
apply(auto)
apply(cases "tl (tl (tl (vctx_stack v)))")
apply(auto)
apply(cases "get_storage (Some inst)")
apply(auto)
(* apply(simp add:sstore_def) *)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "tl (vctx_stack v)")
apply simp
using vctx_next_instruction_def
apply fastforce
defer
defer
apply(cases "index (vctx_stack v) (Suc (nat (uint (get_swap (Some inst)))))")
apply(auto)
apply(cases "index (vctx_stack v) 0")
apply(auto)
apply(cases "get_log (Some inst)")
apply(auto)
using vctx_next_instruction_def apply fastforce
using vctx_next_instruction_def apply fastforce
using vctx_next_instruction_def apply fastforce
using vctx_next_instruction_def apply fastforce
using vctx_next_instruction_def apply fastforce
using vctx_next_instruction_def apply fastforce
apply(cases "get_misc (Some inst)")
apply(auto)

(*apply(simp add:create_def) *)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "tl (vctx_stack v)")
apply(auto)
apply(cases "tl (tl (vctx_stack v))")
apply(auto)
apply(cases "vctx_balance v (cctx_this c) < hd (vctx_stack v)")
apply(auto)

(* apply(simp add:call_def)  *)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "tl (vctx_stack v)")
apply(auto)
apply(cases "tl (tl (vctx_stack v))")
apply(auto)
apply(cases "tl (tl (tl (vctx_stack v)))")
apply(auto)
apply(cases "tl (tl (tl (tl (vctx_stack v))))")
apply(auto)
apply(cases "tl (tl (tl (tl (tl (vctx_stack v)))))")
apply(auto)
apply(cases "tl (tl (tl (tl (tl (tl (vctx_stack v))))))")
apply(auto)
apply(cases "vctx_balance v (cctx_this c) <
    hd (tl (tl (vctx_stack v)))")
apply(auto)
(* apply(simp add:callcode_def) *)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "tl (vctx_stack v)")
apply(auto)
apply(cases "tl (tl (vctx_stack v))")
apply(auto)
apply(cases "tl (tl (tl (vctx_stack v)))")
apply(auto)
apply(cases "tl (tl (tl (tl (vctx_stack v))))")
apply(auto)
apply(cases "tl (tl (tl (tl (tl (vctx_stack v)))))")
apply(auto)
apply(cases "tl (tl (tl (tl (tl (tl (vctx_stack v))))))")
apply(auto)
apply(cases "vctx_balance v (cctx_this c) <
    hd (tl (tl (vctx_stack v)))")
apply(auto)
(* apply(simp add:delegatecall_def) *)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "tl (vctx_stack v)")
apply(auto)
apply(cases "tl (tl (vctx_stack v))")
apply(auto)
apply(cases "tl (tl (tl (vctx_stack v)))")
apply(auto)
apply(cases "tl (tl (tl (tl (vctx_stack v))))")
apply(auto)
apply(cases "tl (tl (tl (tl (tl (vctx_stack v)))))")
apply(auto)
apply(cases "vctx_balance v (cctx_this c) <
    vctx_value_sent v")
apply(auto)
(* apply(simp add:ret_def) *)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "tl (vctx_stack v)")
apply(auto)
(* apply(simp add:suicide_def) *)
apply(cases "vctx_stack v")
apply(auto)
apply(cases "get_pc (Some inst)")
apply(auto)
(* apply(simp add:pc_def) *)

apply(cases "get_stack inst")
apply(auto)

apply(cases "vctx_stack v")
apply(auto)

done

lemma lemma_subtract : 
  "subtract_gas x (InstructionContinue v) = InstructionContinue nv \<Longrightarrow>
   vctx_pc v = vctx_pc nv"
apply auto
done

theorem no_jump_inc_pc :
  "instruction_sem v c inst = InstructionContinue nv \<Longrightarrow>
   vctx_next_instruction v c = Some inst \<Longrightarrow>
   is_inc_pc (vctx_next_instruction v c) \<Longrightarrow>
   vctx_pc nv = vctx_pc v + 1"
apply(subst (asm) inst_gas)
apply(cases "instruction_aux v c inst")
defer
apply(simp)
apply(simp)
  by (metis lemma_subtract no_jump_inc_pc_aux)

theorem push_inc_pc_aux :
  "instruction_aux v c (Stack (PUSH_N lst)) = InstructionContinue nv \<Longrightarrow>
   vctx_next_instruction v c = Some (Stack (PUSH_N lst)) \<Longrightarrow>
   \<not>(lst = []) \<Longrightarrow>
   32 \<ge> length lst \<Longrightarrow>
   vctx_pc nv = vctx_pc v + length lst + 1"
apply(auto simp:instruction_aux_def)
apply(auto simp:vctx_advance_pc_def inst_size_def)
done

theorem push_inc_pc :
  "instruction_sem v c (Stack (PUSH_N lst)) = InstructionContinue nv \<Longrightarrow>
   vctx_next_instruction v c = Some (Stack (PUSH_N lst)) \<Longrightarrow>
   \<not>(lst = []) \<Longrightarrow>
   32 \<ge> length lst \<Longrightarrow>
   vctx_pc nv = vctx_pc v + length lst + 1"
apply(subst (asm) inst_gas)
apply(cases "instruction_aux v c (Stack (PUSH_N lst))")
defer
apply(simp)
apply(simp)
  by (metis lemma_subtract push_inc_pc_aux)

declare is_inc_pc.simps [simp del]
declare inc_pc_one [simp del]
declare lemma_log [simp del]
declare lemma_stack_op_2_1 [simp del]
declare lemma_pop_stack [simp del]

end
