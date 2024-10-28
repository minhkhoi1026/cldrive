//{"a":0,"a_local":3,"b":1,"b_local":4,"out":2,"out_local":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_add(global unsigned int* a, global unsigned int* b, global unsigned int* out) {
  unsigned int a_local[2048];
  unsigned int b_local[2048];
  unsigned int out_local[2048];

local_a:
  for (size_t i = 0; i < 2048; i++) {
    a_local[hook(3, i)] = a[hook(0, i)];
  }

local_b:
  for (size_t i = 0; i < 2048; i++) {
    b_local[hook(4, i)] = b[hook(1, i)];
  }

add_loop:
  for (size_t i = 0; i < 2048; i++) {
    out_local[hook(5, i)] = a_local[hook(3, i)] + b_local[hook(4, i)];
  }

global_out:
  for (size_t i = 0; i < 2048; i++) {
    out[hook(2, i)] = out_local[hook(5, i)];
  }

  return;
}