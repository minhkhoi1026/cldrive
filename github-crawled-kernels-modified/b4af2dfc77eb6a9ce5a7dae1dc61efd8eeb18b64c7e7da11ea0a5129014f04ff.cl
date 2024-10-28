//{"rf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float GAMMA = 42.57748f;
constant float TWOPI = 6.283185307179586476925286766559005768394338798750211641949889185f;
kernel void zerorf(global float* rf) {
  rf[hook(0, get_global_id(0))] = 0.;
}