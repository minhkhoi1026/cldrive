//{"clock":2,"in":0,"out":1,"shared":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void microbench(global float* in, global float* out, int clock) {
  local float shared[6144];
  int tid = get_local_size(0) * get_local_id(1) + get_local_id(0);

 private
  float sum = 0;

  sum = sum + shared[hook(3, tid + 0)];
  sum = sum + shared[hook(3, tid + 128)];
  sum = sum + shared[hook(3, tid + 256)];
  sum = sum + shared[hook(3, tid + 384)];
  sum = sum + shared[hook(3, tid + 512)];
  sum = sum + shared[hook(3, tid + 640)];
  sum = sum + shared[hook(3, tid + 768)];
  sum = sum + shared[hook(3, tid + 896)];

  sum = sum + shared[hook(3, tid + 1024 + 0)];
  sum = sum + shared[hook(3, tid + 1024 + 128)];
  sum = sum + shared[hook(3, tid + 1024 + 256)];
  sum = sum + shared[hook(3, tid + 1024 + 384)];
  sum = sum + shared[hook(3, tid + 1024 + 512)];
  sum = sum + shared[hook(3, tid + 1024 + 640)];
  sum = sum + shared[hook(3, tid + 1024 + 768)];
  sum = sum + shared[hook(3, tid + 1024 + 896)];

  sum = sum + shared[hook(3, tid + 1024 + 1024 + 0)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 128)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 256)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 384)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 512)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 640)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 768)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 896)];

  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 0)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 128)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 256)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 384)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 512)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 640)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 768)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 896)];

  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 0)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 128)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 256)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 384)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 512)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 640)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 768)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 896)];

  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 1024 + 0)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 1024 + 128)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 1024 + 256)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 1024 + 384)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 1024 + 512)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 1024 + 640)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 1024 + 768)];
  sum = sum + shared[hook(3, tid + 1024 + 1024 + 1024 + 1024 + 1024 + 896)];

  out[hook(1, tid)] = sum;
}