//{"alpha":2,"beta":3,"float2":1,"size":4,"vec1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void plane_rotation(global float* vec1, global float* float2, float alpha, float beta, unsigned int size) {
  float tmp1 = 0;
  float tmp2 = 0;

  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    tmp1 = vec1[hook(0, i)];
    tmp2 = float2[hook(1, i)];

    vec1[hook(0, i)] = alpha * tmp1 + beta * tmp2;
    float2[hook(1, i)] = alpha * tmp2 - beta * tmp1;
  }
}