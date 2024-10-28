//{"<recovery-expr>()":7,"<recovery-expr>(ovalues)":6,"iindex":3,"ivalues":2,"nNZ":5,"oindex":1,"ovalues":0,"swapIdx":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void swapIndex_kernel(global T* ovalues, global int* oindex, global const T* ivalues, global const int* iindex, global const int* swapIdx, const int nNZ) {
  int id = get_global_id(0);
  if (id >= nNZ)
    return;

  int idx = swapIdx[hook(4, id)];

  ovalues[hook(6, id)] = ivalues[hook(7, idx)];
  oindex[hook(1, id)] = iindex[hook(3, idx)];
}