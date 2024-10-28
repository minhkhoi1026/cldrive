//{"buffer":0,"dummyBuffer":2,"num_it":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mem_read(global volatile float* buffer, int num_it, global float* dummyBuffer) {
  const int k = get_global_id(0);
  float tmp = 0;

  while (num_it-- != 0)
    tmp += buffer[hook(0, k)];

  *dummyBuffer = tmp;
}