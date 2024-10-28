//{"((const __global float *)(eig + (i + 1) * eig_pitch))":13,"((const __global float *)(eig + (i - 1) * eig_pitch))":12,"((const __global float *)(eig + (i) * eig_pitch))":11,"cols":8,"corners":3,"eig":0,"eig_pitch":1,"g_counter":10,"mask":2,"mask_strip":4,"max_count":9,"pMinMax":5,"qualityLevel":6,"rows":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void findCorners(global const char* eig, const int eig_pitch, global const char* mask, global float2* corners, const int mask_strip, global const float* pMinMax, const float qualityLevel, const int rows, const int cols, const int max_count, global int* g_counter) {
  float threshold = qualityLevel * pMinMax[hook(5, 1)];
  const int j = get_global_id(0);
  const int i = get_global_id(1);

  if (i > 0 && i < rows - 1 && j > 0 && j < cols - 1

  ) {
    const float val = ((global const float*)(eig + (i)*eig_pitch))[hook(11, j)];

    if (val > threshold) {
      float maxVal = val;
      maxVal = fmax(((global const float*)(eig + (i - 1) * eig_pitch))[hook(12, j - 1)], maxVal);
      maxVal = fmax(((global const float*)(eig + (i - 1) * eig_pitch))[hook(12, j)], maxVal);
      maxVal = fmax(((global const float*)(eig + (i - 1) * eig_pitch))[hook(12, j + 1)], maxVal);

      maxVal = fmax(((global const float*)(eig + (i)*eig_pitch))[hook(11, j - 1)], maxVal);
      maxVal = fmax(((global const float*)(eig + (i)*eig_pitch))[hook(11, j + 1)], maxVal);

      maxVal = fmax(((global const float*)(eig + (i + 1) * eig_pitch))[hook(13, j - 1)], maxVal);
      maxVal = fmax(((global const float*)(eig + (i + 1) * eig_pitch))[hook(13, j)], maxVal);
      maxVal = fmax(((global const float*)(eig + (i + 1) * eig_pitch))[hook(13, j + 1)], maxVal);

      if (val == maxVal) {
        const int ind = atomic_inc(g_counter);

        if (ind < max_count) {
          corners[hook(3, ind)].x = val;
          corners[hook(3, ind)].y = __builtin_astype((j | (i << 16)), float);
        }
      }
    }
  }
}