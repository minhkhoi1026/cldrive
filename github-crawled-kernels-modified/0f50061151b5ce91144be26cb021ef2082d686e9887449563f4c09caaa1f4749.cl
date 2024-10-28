//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void wideDataTransfer(global float* in, global float* out) {
  size_t STRIDE_INDEX = 4;
  size_t id = (get_group_id(0) * get_local_size(0) + get_local_id(0)) * STRIDE_INDEX;
  size_t offsetA = id;
  size_t offsetB = (id + 1);
  size_t offsetC = (id + 2);
  size_t offsetD = (id + 3);

  float16 A = vload16(offsetA, in);
  float16 B = vload16(offsetB, in);
  float16 C = vload16(offsetC, in);
  float16 D = vload16(offsetD, in);

  vstore16(A, offsetA, out);
  vstore16(B, offsetB, out);
  vstore16(C, offsetC, out);
  vstore16(D, offsetD, out);
}