//{"A":0,"nbPoint":2,"ray":3,"res":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct point {
  float x;
  float y;
};

kernel void pi(global struct point* A, global int* res, const int nbPoint, const float ray) {
  const int idx = 32 * get_local_size(0) * get_group_id(0) + get_local_id(0);
  int dim = get_local_size(0);
  if (idx < (int)(nbPoint - 32 * dim))
    for (int j = 0; j < 32; j++) {
      int i = idx + dim * j;
      res[hook(1, i)] = (A[hook(0, i)].x * A[hook(0, i)].x + A[hook(0, i)].y * A[hook(0, i)].y <= ray);
    }
}