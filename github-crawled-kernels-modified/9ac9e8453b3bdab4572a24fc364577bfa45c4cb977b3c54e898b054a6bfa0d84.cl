//{"num":1,"set":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SetNum(global float4* set, float num) {
  set[hook(0, get_global_id(0))].xyzw = num;
}