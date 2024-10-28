//{"a":0,"b":1,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_doTinyTask(int a, int b, global float* result) {
  int sum = a + b;

  int threadID = get_local_id(0);
  if (threadID >= 1024)
    *result = sum;
}