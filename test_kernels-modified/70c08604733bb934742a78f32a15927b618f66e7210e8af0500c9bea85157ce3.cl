//{"ptr":2,"source":1,"target":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef size_t size_t;
kernel void copy(global int* target, global size_t* source) {
  int id = get_global_id(0);
  global int* ptr = (global int*)source[hook(1, 0)];
  target[hook(0, id)] = ptr[hook(2, id)];
  if (ptr[hook(2, id)] != 0)
    printf("%d ", ptr[hook(2, id)]);
}