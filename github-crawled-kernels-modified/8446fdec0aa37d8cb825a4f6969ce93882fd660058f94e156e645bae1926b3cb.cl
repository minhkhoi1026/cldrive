//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_unstructured_branch0(global int* src, global int* dst) {
  int id = (int)get_global_id(0);
  dst[hook(1, id)] = src[hook(0, id)];
  if (dst[hook(1, id)] >= 0)
    goto label;

  do {
    dst[hook(1, id)] = 1;
  label:
    id += get_local_size(0);
  } while (id < 32);
}