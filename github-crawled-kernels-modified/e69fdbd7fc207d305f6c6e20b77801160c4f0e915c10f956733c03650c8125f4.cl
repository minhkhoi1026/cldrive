//{"binA":3,"binB":4,"binL":2,"dest":1,"sharpness":5,"srce":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clQuantizeLAB(read_only image2d_t srce, write_only image2d_t dest, float binL, float binA, float binB, float sharpness) {
  const sampler_t sampler = 0 | 0x10 | 4;
  int x = get_global_id(0);
  int y = get_global_id(1);
  float4 LAB = read_imagef(srce, sampler, (int2)(x, y));

  float bL = LAB.x - fmod(LAB.x, binL) + binL / 2.0;
  float bA = LAB.y - fmod(LAB.y, binA) + binA / 2.0;
  float bB = LAB.z - fmod(LAB.z, binB) + binB / 2.0;
  LAB.x = bL + binL / 2.0f * tanh(sharpness * (LAB.x - bL));
  LAB.y = bA + binA / 2.0f * tanh(sharpness * (LAB.y - bA));
  LAB.z = bB + binB / 2.0f * tanh(sharpness * (LAB.z - bB));

  write_imagef(dest, (int2)(x, y), LAB);
}