//{"Block_log2":2,"IR_In":0,"IR_In_sz":3,"IR_Out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyIRKernel16bitInter(const global unsigned int* IR_In, global float2* IR_Out, unsigned int Block_log2, unsigned int IR_In_sz) {
  unsigned int id = get_global_id(0);
  unsigned int glbl_sz = get_global_size(0);
  unsigned int id_rem = id - ((id >> Block_log2) << Block_log2);
  unsigned int id_out = ((id >> Block_log2) << (Block_log2 + 1)) + id_rem;
  float2 IR_L = (float2)(0, 0);
  float2 IR_R = (float2)(0, 0);

  IR_Out[hook(1, id_out + (1 << Block_log2))] = IR_L;
  IR_Out[hook(1, id_out + (1 << Block_log2) + (glbl_sz << 1))] = IR_L;

  unsigned int IR = (id < IR_In_sz) ? IR_In[hook(0, id)] : 0;

  int i_L = (((int)(IR & 0xffff) << 16) >> 16);
  int i_R = ((int)IR >> 16);
  IR_L.s0 = (float)i_L;
  IR_R.s0 = (float)i_R;
  IR_Out[hook(1, id_out)] = IR_L;

  IR_Out[hook(1, id_out + (glbl_sz << 1))] = IR_R;
}