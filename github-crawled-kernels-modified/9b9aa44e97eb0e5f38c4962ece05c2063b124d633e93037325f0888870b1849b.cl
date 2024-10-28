//{"clock":2,"in":0,"out":1,"shared":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void microbench(global float* in, global float* out, int clock) {
  local float shared[6144];
  int tid = get_local_size(0) * get_local_id(1) + get_local_id(0);

  for (int i = 0; i < 6144 - 127; i += 128) {
    shared[hook(3, tid + i)] = tid + i;
  }
  int sum = 0;
  for (int i = 0; i < 6144 - 127; i += 128) {
    sum += shared[hook(3, tid + i)];
  }
}