//{"dst":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_kernel_arg(global unsigned int* dst, float3 src) {
  size_t gid = get_global_id(0);

  switch (gid % 3) {
    case 0:
      dst[hook(0, gid)] = src.x;
      break;
    case 1:
      dst[hook(0, gid)] = src.y;
      break;
    case 2:
      dst[hook(0, gid)] = src.z;
      break;
    default:
      break;
  }
}