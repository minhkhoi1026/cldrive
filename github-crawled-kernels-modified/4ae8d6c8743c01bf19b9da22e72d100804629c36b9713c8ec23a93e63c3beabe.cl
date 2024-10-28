//{"rendered":0,"selDist":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void setZero(global ushort* rendered, global float* selDist) {
  const unsigned int i = get_global_id(0);
  rendered[hook(0, i)] = 0;
  selDist[hook(1, i)] = 10;
}