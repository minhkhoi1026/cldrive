//{"As":3,"d_MatA":0,"d_rows":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transMatrix(global float* d_MatA, global float* output, global int* d_rows, local float* As) {
  unsigned int xIndex = get_global_id(0);
  unsigned int yIndex = get_global_id(1);

  if ((xIndex < (*d_rows)) && (yIndex < (*d_rows))) {
    unsigned int index_in = yIndex * (*d_rows) + xIndex;
    As[hook(3, get_local_id(1) * (16) + get_local_id(0))] = d_MatA[hook(0, index_in)];
  }

  barrier(0x01);

  xIndex = get_group_id(1) * 16 + get_local_id(0);
  yIndex = get_group_id(0) * 16 + get_local_id(1);
  if ((xIndex < (*d_rows)) && (yIndex < (*d_rows))) {
    unsigned int index_out = yIndex * (*d_rows) + xIndex;
    output[hook(1, index_out)] = As[hook(3, get_local_id(0) * (16) + get_local_id(1))];
  }
}