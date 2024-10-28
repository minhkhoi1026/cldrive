//{"ga":3,"in":1,"out":2,"size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int calcutate(int index) {
  int a = (index * 32) & 128;
  return a;
}

kernel void test(int size, global int* in, global int* out) {
  int idx = get_global_id(0);

  if (idx >= size) {
    return;
  }

  int ga[10240 + 4096 + 200] = {1};

  out[hook(2, idx)] = ga[hook(3, idx % 10240 + 4096 + 200)];
}