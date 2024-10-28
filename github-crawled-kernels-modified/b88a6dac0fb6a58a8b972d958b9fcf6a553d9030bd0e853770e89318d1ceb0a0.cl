//{"dt":2,"num":1,"position":0,"vel":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple(global float4* position, int num, float dt, float4 vel) {
  int i = get_global_id(0);
  if (i >= num)
    return;

  float4 p = position[hook(0, i)];

  for (int j = 0; j < 10000; j++) {
    p += dt * vel;
  }

  position[hook(0, i)] = p;
}