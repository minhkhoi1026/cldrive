//{"axis":2,"dest":1,"filter":3,"size":4,"srce":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clConvolute(global float4* srce, global float4* dest, int4 axis, global float* filter, int size) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);
  int sx = get_global_size(0);
  int sy = get_global_size(1);
  int sz = get_global_size(2);

  int limit = size / 2;
  float4 DEST = (float4)0;
  for (int i = -limit; i < limit + 1; i++) {
    int gx = min(max(x + i * axis.x, 0), sx - 1);
    int gy = min(max(y + i * axis.y, 0), sy - 1);
    int gz = min(max(z + i * axis.z, 0), sz - 1);
    float4 SRCE = srce[hook(0, gz * sx * sy + gy * sx + gx)];
    DEST += SRCE * filter[hook(3, i + limit)];
  }
  dest[hook(1, z * sx * sy + y * sx + x)] = DEST;
}