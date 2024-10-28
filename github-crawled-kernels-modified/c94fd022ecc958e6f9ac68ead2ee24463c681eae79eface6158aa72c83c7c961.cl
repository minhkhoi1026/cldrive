//{"level_count":0,"levels":1,"location":2,"res":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simplex_3d(global const int* level_count, global const double* levels, global const double* location, global double* res) {
  res[hook(3, 0)] = 0.0;
}