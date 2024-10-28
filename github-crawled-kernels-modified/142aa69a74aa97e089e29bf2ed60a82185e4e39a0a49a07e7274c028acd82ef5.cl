//{"float2":2,"size":0,"vec1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum(const int size, const global float* vec1, global float* float2) {
  int ii = get_global_id(0);

  if (ii < size)
    float2[hook(2, ii)] += vec1[hook(1, ii)];
}