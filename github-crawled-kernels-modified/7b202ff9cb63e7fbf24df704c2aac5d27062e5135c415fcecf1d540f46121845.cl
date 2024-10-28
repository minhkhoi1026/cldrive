//{"N":2,"d_Input":1,"d_Result":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global float* d_Result, global float* d_Input, int N) {
  const int tid = get_global_id(0);
  const int threadN = get_global_size(0);

  float sum = 0;

  for (int pos = tid; pos < N; pos += threadN)
    sum += d_Input[hook(1, pos)];

  d_Result[hook(0, tid)] = sum;
}