//{"from":1,"to":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_16_bytes(global float4* const restrict to, global const float4* const restrict from) {
  if (get_global_id(0) == 0) {
    to[hook(0, 0)] = from[hook(1, 0)];
  }
}