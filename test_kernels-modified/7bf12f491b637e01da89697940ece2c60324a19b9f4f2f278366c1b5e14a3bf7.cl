//{"dconst":3,"force":2,"params":0,"vel":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void drag_force(global float4* params, global float4* vel, global float4* force, float dconst) {
  int i = get_global_id(0);

  bool fixed = 0 < params[hook(0, i)].x;
  if (fixed) {
    return;
  }

  force[hook(2, i)] += -dconst * vel[hook(1, i)];
}