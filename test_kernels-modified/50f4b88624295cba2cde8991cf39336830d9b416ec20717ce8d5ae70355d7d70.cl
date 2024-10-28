//{"blockLength":2,"in":0,"maxBlockNum":3,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void amdAccumulateBlocks(global const float* in, global float* out, int blockLength, int maxBlockNum) {
  int glbl_id = get_global_id(0);

  out[hook(1, glbl_id)] = in[hook(0, glbl_id)];
  for (int block = 1; block < maxBlockNum; block++) {
    out[hook(1, glbl_id)] += in[hook(0, glbl_id + block * blockLength)];
  }
}