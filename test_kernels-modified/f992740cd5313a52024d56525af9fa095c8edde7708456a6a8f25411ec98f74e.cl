//{"a":1,"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Fill(global float* data, float a) {
  data[hook(0, get_global_id(0))] = a;
}