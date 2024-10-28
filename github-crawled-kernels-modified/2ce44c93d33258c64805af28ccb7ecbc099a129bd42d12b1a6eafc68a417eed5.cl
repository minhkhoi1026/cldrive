//{"v":0,"v2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void frameDiffDoubleFloat(global double* v, global float* v2) {
  unsigned int i = get_global_id(0);
  if (abs((int)(v[hook(0, i)] - v2[hook(1, i)])) < 20) {
    v[hook(0, i)] = 0;
  }
}