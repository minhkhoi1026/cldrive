//{"dest":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clMemSetBuffer(global float4* dest, float4 value) {
  dest[hook(0, get_global_id(0))] = value;
}