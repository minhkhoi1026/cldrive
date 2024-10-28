//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void trig(global const float4* a, global float4* b, float c) {
  int gid = get_global_id(0);

  switch (gid % 5) {
    case 0:
      b[hook(1, gid)] = cos(a[hook(0, gid)]);
      break;
    case 1:
      b[hook(1, gid)] = fabs(a[hook(0, gid)]) + c;
      break;
    case 2:
      b[hook(1, gid)] = sin(a[hook(0, gid)]);
      break;
    case 3:
      b[hook(1, gid)] = sqrt(a[hook(0, gid)]);
      break;
    case 4:
      b[hook(1, gid)] = tan(a[hook(0, gid)]);
      break;
  }
}