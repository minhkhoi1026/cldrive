//{"in":2,"ncol":1,"nrow":0,"out":3,"sdata":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_transpose(unsigned int nrow, unsigned int ncol, global const float* in, global float* out, local float* sdata) {
  unsigned int gidx = get_global_id(0);
  unsigned int gidy = get_global_id(1);

  if ((gidx < ncol) && (gidy < nrow)) {
    unsigned int id_in = gidy * ncol + gidx;
    sdata[hook(4, get_local_id(1) * (16 + 1) + get_local_id(0))] = in[hook(2, id_in)];
  }

  barrier(0x01);

  gidx = get_group_id(1) * 16 + get_local_id(0);
  gidy = get_group_id(0) * 16 + get_local_id(1);
  if ((gidx < nrow) && (gidy < ncol)) {
    unsigned int id_out = gidy * nrow + gidx;
    out[hook(3, id_out)] = sdata[hook(4, get_local_id(0) * (16 + 1) + get_local_id(1))];
  }
}