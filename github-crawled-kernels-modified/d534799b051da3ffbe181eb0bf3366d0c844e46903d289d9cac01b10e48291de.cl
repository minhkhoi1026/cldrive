//{"N":3,"out":0,"w":1,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int get_index(int nelems, int index) {
  if (index == -1) {
    index = get_global_id(0);
  } else {
    index += get_global_size(0);
  }

  if (index >= nelems)
    index = -1;

  return index;
}

kernel void scalar_minus(global float* out, float w, global const float* x, int N) {
  int id = get_index(N, -1);
  while (id >= 0) {
    out[hook(0, id)] = w - x[hook(2, id)];
    id = get_index(N, id);
  }
}