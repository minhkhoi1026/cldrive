//{"inc":0,"num":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Increment(global float4* inc, float num) {
  inc[hook(0, get_global_id(0))].xyzw += num;
}