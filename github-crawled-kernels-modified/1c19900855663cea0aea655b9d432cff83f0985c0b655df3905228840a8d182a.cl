//{"norm":1,"w":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void projectOntoL2Ball(global float* w, float norm) {
  w[hook(0, get_global_id(0))] /= norm;
}