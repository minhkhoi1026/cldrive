//{"Block_log2":2,"IR_In":0,"IR_In_sz":3,"IR_Out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyIRKernel(const global float* IR_In, global float2* IR_Out, unsigned int Block_log2, unsigned int IR_In_sz) {
  unsigned int id = get_global_id(0);
  unsigned int id_rem = id - ((id >> Block_log2) << Block_log2);
  unsigned int id_out = ((id >> Block_log2) << (Block_log2 + 1)) + id_rem;
  float2 IR = (float2)(0, 0);
  IR_Out[hook(1, id_out + (1 << Block_log2))] = IR;
  IR.s0 = (id < IR_In_sz) ? IR_In[hook(0, id)] : 0;
  IR_Out[hook(1, id_out)] = IR;
}