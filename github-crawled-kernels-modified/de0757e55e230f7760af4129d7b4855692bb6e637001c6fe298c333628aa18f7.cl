//{"I":2,"O":3,"nx":0,"ny":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blur2D_scanline_priv(int nx, int ny, global float* I, global float* O) {
  int ig = get_global_id(0) + 1;
  float3 Lm = (float3)(I[hook(2, ig - 1)], I[hook(2, ig)], I[hook(2, ig + 1)]);
  ig += nx;
  float3 L0 = (float3)(I[hook(2, ig - 1)], I[hook(2, ig)], I[hook(2, ig + 1)]);
  for (int iy = 1; iy < (ny - 1); iy++) {
    ig += nx;
    float3 Lp = (float3)(I[hook(2, ig - 1)], I[hook(2, ig)], I[hook(2, ig + 1)]);
    O[hook(3, ig - nx)] = (Lm.x + Lm.y + Lm.z + L0.x + L0.y + L0.z + Lp.x + Lp.y + Lp.z) * 0.11111111111f;
    Lm = L0;
    L0 = Lp;
  }
}