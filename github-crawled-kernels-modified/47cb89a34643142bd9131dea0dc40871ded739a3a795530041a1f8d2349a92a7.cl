//{"(ptr + 256 + 256)":3,"(ptr + 256)":2,"img":0,"ptr":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram(global unsigned int* img, volatile global unsigned int* ptr) {
  int i = get_global_id(0);
  int index;

  index = img[hook(0, 3 * i)];
  atomic_inc(&ptr[hook(1, index)]);

  index = img[hook(0, 3 * i + 1)];
  atomic_inc(&(ptr + 256)[hook(2, index)]);

  index = img[hook(0, 3 * i + 2)];
  atomic_inc(&(ptr + 256 + 256)[hook(3, index)]);
}