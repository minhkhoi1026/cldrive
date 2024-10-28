//{"dst":1,"num":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AddNum(global float* src, global float* dst, float num) {
  dst[hook(1, get_global_id(0))] = src[hook(0, get_global_id(0))] + num;
}