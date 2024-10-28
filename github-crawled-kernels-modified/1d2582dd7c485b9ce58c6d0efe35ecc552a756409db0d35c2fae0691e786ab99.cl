//{"input":0,"output":1,"windowHalf":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void vectorMedianFilter(read_only image2d_t input, write_only image2d_t output, private int windowHalf) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  float2 bestVector;
  float bestSum = 0x1.fffffep127f;
  for (int y = -windowHalf; y <= windowHalf; ++y) {
    for (int x = -windowHalf; x <= windowHalf; ++x) {
      float2 a_m = read_imagef(input, sampler, pos + (int2)(x, y)).xy;
      float sum = 0.0f;
      for (int y2 = -windowHalf; y2 <= windowHalf; ++y2) {
        for (int x2 = -windowHalf; x2 <= windowHalf; ++x2) {
          float2 a_i = read_imagef(input, sampler, pos + (int2)(x2, y2)).xy;

          sum += length(a_m - a_i);
        }
      }
      if (sum < bestSum) {
        bestVector = a_m;
        bestSum = sum;
      }
    }
  }

  write_imagef(output, pos, bestVector.xyyy);
}