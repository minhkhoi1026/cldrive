//{"input":0,"nfeatures":3,"npoints":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void invert_mapping(global float* input, global float* output, int npoints, int nfeatures) {
  int point_id = get_local_id(0) + get_local_size(0) * get_group_id(0);
  int i;

  if (point_id < npoints) {
    for (i = 0; i < nfeatures; i++)
      output[hook(1, point_id + npoints * i)] = input[hook(0, point_id * nfeatures + i)];
  }
  return;
}