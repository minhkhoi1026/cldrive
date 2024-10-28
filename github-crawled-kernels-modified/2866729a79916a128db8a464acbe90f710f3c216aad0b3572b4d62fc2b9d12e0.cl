//{"dst":1,"src1":2,"src2":3,"t":4,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blend4(int x, global float* dst, global float* src1, global float* src2, float t) {
  int id = get_global_id(1) * get_global_size(0) + get_global_id(0);
  dst[hook(1, id)] = mix(src1[hook(2, id)], src2[hook(3, id)], t);
}