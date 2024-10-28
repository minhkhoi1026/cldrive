//{"vectorA":0,"vectorB":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecinit(global float* vectorA, global float* vectorB) {
  vectorA[hook(0, get_global_id(0))] = (float)get_global_id(0);
  vectorB[hook(1, get_global_id(0))] = (float)get_global_id(0) / 2;
}