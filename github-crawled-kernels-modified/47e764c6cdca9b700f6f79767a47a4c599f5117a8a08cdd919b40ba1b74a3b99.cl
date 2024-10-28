//{"dst":1,"num":0,"src":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reverse4(int num, global float4* dst, global float4* src) {
  int id = get_global_id(0);
  if (id >= num)
    return;
  dst[hook(1, num - id - 1)].wzyx = src[hook(2, id)].xyzw;
}