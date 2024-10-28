//{"n":0,"offsetA":2,"offsetB":4,"paramA":1,"paramB":3,"partialSum_d":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void s_dot_kernel_naive(int n, global float* paramA, int offsetA, global float* paramB, int offsetB, global float* partialSum_d) {
  unsigned int i;
  unsigned int tid = get_local_id(0);
  unsigned int totalThreads = get_num_groups(0) * (128);
  unsigned int offset = (128) * get_group_id(0);

  for (i = offset + tid; i < n; i += totalThreads) {
    partialSum_d[hook(5, i)] = paramA[hook(1, offsetA + i)] * paramB[hook(3, offsetB + i)];
  }
}