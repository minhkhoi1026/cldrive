//{"alphas":1,"enls":0,"enls_nobias":3,"height_ori":4,"width_ori":5,"wsums":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float enl_nobias(float enl, float alpha, float wsum) {
  return enl / (pow(1.0f - alpha, 2.0f) + (pow(alpha, 2.0f) + 2.0f * alpha * (1.0f - alpha) / wsum) * enl);
}

kernel void compute_enls_nobias(global float* enls, global float* alphas, global float* wsums, global float* enls_nobias, const int height_ori, const int width_ori) {
  const int tx = get_global_id(0);
  const int ty = get_global_id(1);

  if (tx < height_ori && ty < width_ori) {
    const int idx = tx * width_ori + ty;
    enls_nobias[hook(3, idx)] = enl_nobias(enls[hook(0, idx)], alphas[hook(1, idx)], wsums[hook(2, idx)]);
  }
}