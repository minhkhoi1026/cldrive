//{"global_floats":1,"local_floats":2,"num":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mult(float num, global float* global_floats, local float4* local_floats) {
  int id = get_global_id(0);
  local_floats[hook(2, id)] = vload4(id, global_floats);

  local_floats[hook(2, id)] *= num;
  vstore4(local_floats[hook(2, id)], id, global_floats);
}