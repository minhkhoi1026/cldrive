//{"input":0,"prob":3,"rand":2,"scale":4,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void yoloswag420blazeit360noscope(global float* input, int size, global float* rand, float prob, float scale) {
  int id = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (id < size)
    input[hook(0, id)] = (rand[hook(2, id)] < prob) ? 0 : input[hook(0, id)] * scale;
}