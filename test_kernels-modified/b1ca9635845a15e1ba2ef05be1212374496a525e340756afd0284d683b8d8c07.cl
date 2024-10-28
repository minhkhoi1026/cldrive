//{"input":1,"num_threads":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Cast(global float* out, global const int* input, const int num_threads) {
  int tid = get_global_id(0);
  if (tid < num_threads)
    out[hook(0, tid)] = (float)(input[hook(1, tid)]);
}