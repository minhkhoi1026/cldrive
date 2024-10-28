//{"lambda2":3,"p":0,"p_d1":1,"p_d2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void leapfrog(global float* p, global float* p_d1, global float* p_d2, float lambda2) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);
  size_t z = get_global_id(2);

  if (x > 0 && x < get_global_size(0) - 1 && y > 0 && y < get_global_size(1) - 1 && z > 0 && z < get_global_size(2) - 1) {
    p[hook(0, ((z) * 128 * 128 + (y) * 128 + (x)))] =

        lambda2 * (p_d1[hook(1, ((z) * 128 * 128 + (y) * 128 + (x + 1)))] + p_d1[hook(1, ((z) * 128 * 128 + (y) * 128 + (x - 1)))] + p_d1[hook(1, ((z) * 128 * 128 + (y + 1) * 128 + (x)))] + p_d1[hook(1, ((z) * 128 * 128 + (y - 1) * 128 + (x)))] + p_d1[hook(1, ((z + 1) * 128 * 128 + (y) * 128 + (x)))] + p_d1[hook(1, ((z - 1) * 128 * 128 + (y) * 128 + (x)))]) + 2.0f * (1.0f - 3.0f * lambda2) * p_d1[hook(1, ((z) * 128 * 128 + (y) * 128 + (x)))] - p_d2[hook(2, ((z) * 128 * 128 + (y) * 128 + (x)))];
  }
}