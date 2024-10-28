//{"destpos":2,"destvel":3,"srcpos":0,"srcvel":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy(global float4* srcpos, global float4* srcvel, global float4* destpos, global float4* destvel) {
  int i = get_global_id(0);
  destpos[hook(2, i)] = srcpos[hook(0, i)];
  destvel[hook(3, i)] = srcvel[hook(1, i)];
}