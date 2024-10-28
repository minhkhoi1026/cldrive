//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_atomics(global const int* in, global int* out) {
  size_t offset = get_global_id(0);
  size_t size = get_global_size(0);
  atomic_add(&out[hook(1, offset)], in[hook(0, offset)]);
  atomic_sub(&out[hook(1, offset + size)], in[hook(0, offset + size)]);
  atomic_xchg(&out[hook(1, offset + 2 * size)], in[hook(0, offset + 2 * size)]);
  atomic_inc(&out[hook(1, offset + 3 * size)]);
  atomic_dec(&out[hook(1, offset + 4 * size)]);
  atomic_cmpxchg(&out[hook(1, offset + 5 * size)], in[hook(0, offset + 5 * size)], in[hook(0, offset + 5 * size)]);
  atomic_min(&out[hook(1, offset + 6 * size)], in[hook(0, offset + 6 * size)]);
  atomic_max(&out[hook(1, offset + 7 * size)], in[hook(0, offset + 7 * size)]);
  atomic_and(&out[hook(1, offset + 8 * size)], in[hook(0, offset + 8 * size)]);
  atomic_or(&out[hook(1, offset + 9 * size)], in[hook(0, offset + 9 * size)]);
  atomic_xor(&out[hook(1, offset + 10 * size)], in[hook(0, offset + 10 * size)]);
}