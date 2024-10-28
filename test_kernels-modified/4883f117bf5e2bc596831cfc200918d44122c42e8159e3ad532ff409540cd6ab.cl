//{"g_idata":0,"g_odata":1,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduceNoLocal(global float* g_idata, global float* g_odata, unsigned int n) {
  float sum = 0.0f;
  for (int i = 0; i < n; i++) {
    sum += g_idata[hook(0, i)];
  }
  g_odata[hook(1, 0)] = sum;
}