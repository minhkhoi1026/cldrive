//{"logAvgLum_acc":0,"num_reduc_bins":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GL_to_CL(unsigned int val);
float3 RGBtoXYZ(float3 rgb);
const sampler_t sampler = 0 | 0 | 0x10;
kernel void finalReduc(global float* logAvgLum_acc, const unsigned int num_reduc_bins) {
  if (get_global_id(0) == 0) {
    float logAvgLum = 0.f;
    for (int i = 0; i < num_reduc_bins; i++) {
      logAvgLum += logAvgLum_acc[hook(0, i)];
    }
    logAvgLum_acc[hook(0, 0)] = exp(logAvgLum / ((float)16 * 128));
  } else
    return;
}