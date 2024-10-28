//{"factor":2,"inputImage":0,"iv":3,"outputImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float ran1(int idum, local int* iv) {
  int j;
  int k;
  int iy = 0;

  int tid = get_local_id(0);

  for (j = 4; j >= 0; j--) {
    k = idum / 127773;
    idum = 16807 * (idum - k * 127773) - 2836 * k;

    if (idum < 0)
      idum += 2147483647;

    if (j < 4)
      iv[hook(3, 4 * tid + j)] = idum;
  }
  iy = iv[hook(3, 4 * tid)];

  k = idum / 127773;
  idum = 16807 * (idum - k * 127773) - 2836 * k;

  if (idum < 0)
    idum += 2147483647;

  j = iy / (1 + (2147483647 - 1) / 4);
  iy = iv[hook(3, 4 * tid + j)];
  return ((1.0f / 2147483647) * iy);
}

kernel void noise_uniform(global uchar4* inputImage, global uchar4* outputImage, int factor) {
  int pos = get_global_id(0) + get_global_id(1) * get_global_size(0);

  float4 temp = convert_float4(inputImage[hook(0, pos)]);

  float avg = (temp.x + temp.y + temp.z + temp.y) / 4;

  local int iv[4 * 64];

  float dev = ran1(-avg, iv);
  dev = (dev - 0.5f) * factor;

  outputImage[hook(1, pos)] = convert_uchar4_sat(temp + (float4)(dev));
}