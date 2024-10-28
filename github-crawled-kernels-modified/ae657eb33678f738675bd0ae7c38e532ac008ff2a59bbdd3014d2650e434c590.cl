//{"count":3,"dir":1,"dira":4,"indices":0,"o":2,"oa":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rayResort(const global int* indices, global float* dir, global float* o, int count) {
  int iGID = get_global_id(0);

  if (iGID >= count)
    return;

  int i = indices[hook(0, iGID)];
  float4 dira, oa;
  dira = (float4)(dir[hook(1, iGID * 3)], dir[hook(1, iGID * 3 + 1)], dir[hook(1, iGID * 3 + 2)], 0);
  oa = (float4)(o[hook(2, iGID * 3)], o[hook(2, iGID * 3 + 1)], o[hook(2, iGID * 3 + 2)], 0);

  barrier(0x02);

  dir[hook(1, 3 * i)] = dira[hook(4, 0)];
  dir[hook(1, 3 * i + 1)] = dira[hook(4, 1)];
  dir[hook(1, 3 * i + 2)] = dira[hook(4, 2)];
  o[hook(2, 3 * i)] = oa[hook(5, 0)];
  o[hook(2, 3 * i + 1)] = oa[hook(5, 1)];
  o[hook(2, 3 * i + 2)] = oa[hook(5, 2)];
}