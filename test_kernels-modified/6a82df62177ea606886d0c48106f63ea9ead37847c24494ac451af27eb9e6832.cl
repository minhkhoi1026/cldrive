//{"base":0,"fine":1,"length":3,"rands":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GenerateNoise(float base, float fine, global float* rands, int length) {
  int gid = get_global_id(0);

  if (gid >= length) {
    return;
  }

  rands[hook(2, gid)] = base * gid + fine / (base + gid) + 1 / gid;
}