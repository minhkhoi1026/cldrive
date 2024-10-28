//{"value":1,"valueLocal":2,"vector":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void example2(global float* vector, float value, local float* valueLocal) {
  int local_x = get_local_id(0);
  int global_x = get_global_id(0);

  if (local_x == 0) {
    *valueLocal = value;
  }

  barrier(0x01);

  vector[hook(0, global_x)] = vector[hook(0, global_x)] * *valueLocal;

  barrier(0x02);
}