//{"out":0,"vec":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecload(global int* out, int4 vec) {
  out[hook(0, 0)] = vec.s0;
  out[hook(0, 1)] = vec.s1;
  out[hook(0, 2)] = vec.s2;
  out[hook(0, 3)] = vec.s3;

  out[hook(0, 4)] = vec.x;
  out[hook(0, 5)] = vec.y;
  out[hook(0, 6)] = vec.z;
  out[hook(0, 7)] = vec.w;
}