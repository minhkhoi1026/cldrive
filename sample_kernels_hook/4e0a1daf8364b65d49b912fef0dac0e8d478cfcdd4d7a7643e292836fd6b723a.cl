
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 firstEigenVector(local float* matrix) {
  float4 v = (float4)(1.0f, 1.0f, 1.0f, 0.0f);
  for (int i = 0; i < 8; i++) {
    float x = v.x * matrix[hook(8, 0)] + v.y * matrix[hook(8, 1)] + v.z * matrix[hook(8, 2)];
    float y = v.x * matrix[hook(8, 1)] + v.y * matrix[hook(8, 3)] + v.z * matrix[hook(8, 4)];
    float z = v.x * matrix[hook(8, 2)] + v.y * matrix[hook(8, 4)] + v.z * matrix[hook(8, 5)];
    float m = max(max(x, y), z);
    float iv = 1.0f / m;

    v.x = x * iv;
    v.y = y * iv;
    v.z = z * iv;
  }

  return v;
}

void colorSums(local const float4* colors, local float4* sums) {
  const int idx = get_local_id(0);

  sums[hook(9, idx)] = colors[hook(10, idx)];
  sums[hook(9, idx)] += sums[hook(9, idx ^ 8)];
  sums[hook(9, idx)] += sums[hook(9, idx ^ 4)];
  sums[hook(9, idx)] += sums[hook(9, idx ^ 2)];
  sums[hook(9, idx)] += sums[hook(9, idx ^ 1)];
}

float4 bestFitLine(local const float4* colors, float4 color_sum, local float* covariance) {
  const int idx = get_local_id(0);

  float4 diff = colors[hook(10, idx)] - color_sum * 0.0625f;

  covariance[hook(11, 6 * idx + 0)] = diff.x * diff.x;
  covariance[hook(11, 6 * idx + 1)] = diff.x * diff.y;
  covariance[hook(11, 6 * idx + 2)] = diff.x * diff.z;
  covariance[hook(11, 6 * idx + 3)] = diff.y * diff.y;
  covariance[hook(11, 6 * idx + 4)] = diff.y * diff.z;
  covariance[hook(11, 6 * idx + 5)] = diff.z * diff.z;

  for (int d = 8; d > 0; d >>= 1) {
    if (idx < d) {
      covariance[hook(11, 6 * idx + 0)] += covariance[hook(11, 6 * (idx + d) + 0)];
      covariance[hook(11, 6 * idx + 1)] += covariance[hook(11, 6 * (idx + d) + 1)];
      covariance[hook(11, 6 * idx + 2)] += covariance[hook(11, 6 * (idx + d) + 2)];
      covariance[hook(11, 6 * idx + 3)] += covariance[hook(11, 6 * (idx + d) + 3)];
      covariance[hook(11, 6 * idx + 4)] += covariance[hook(11, 6 * (idx + d) + 4)];
      covariance[hook(11, 6 * idx + 5)] += covariance[hook(11, 6 * (idx + d) + 5)];
    }
  }

  return firstEigenVector(covariance);
}

void sortColors(local const float* values, local int* ranks) {
  const int tid = get_local_id(0);

  int rank = 0;

  for (int i = 0; i < 16; i++) {
    rank += (values[hook(12, i)] < values[hook(12, tid)]);
  }

  ranks[hook(13, tid)] = rank;

  for (int i = 0; i < 15; i++) {
    if (tid > i && ranks[hook(13, tid)] == ranks[hook(13, i)])
      ++ranks[hook(13, tid)];
  }
}

void loadColorBlock(global const unsigned int* image, local float4* colors, local float4* sums, local int* xrefs, local float* temp, int groupOffset) {
  const int bid = get_group_id(0) + groupOffset;
  const int idx = get_local_id(0);

  float4 tmp;

  if (idx < 16) {
    unsigned int c = image[hook(1, (bid) * 16 + idx)];

    colors[hook(10, idx)].x = ((c >> 0) & 0xFF) * 0.003921568627f;
    colors[hook(10, idx)].y = ((c >> 8) & 0xFF) * 0.003921568627f;
    colors[hook(10, idx)].z = ((c >> 16) & 0xFF) * 0.003921568627f;

    colorSums(colors, sums);
    float4 axis = bestFitLine(colors, sums[hook(9, idx)], temp);

    temp[hook(14, idx)] = colors[hook(10, idx)].x * axis.x + colors[hook(10, idx)].y * axis.y + colors[hook(10, idx)].z * axis.z;

    sortColors(temp, xrefs);

    tmp = colors[hook(10, idx)];

    colors[hook(10, xrefs[ihook(15, idx))] = tmp;
  }
}

float4 roundAndExpand(float4 v, ushort* w) {
  ushort x = rint(clamp(v.x, 0.0f, 1.0f) * 31.0f);
  ushort y = rint(clamp(v.y, 0.0f, 1.0f) * 63.0f);
  ushort z = rint(clamp(v.z, 0.0f, 1.0f) * 31.0f);

  *w = ((x << 11) | (y << 5) | z);
  v.x = x * 0.03227752766457f;
  v.y = y * 0.01583151765563f;
  v.z = z * 0.03227752766457f;
  return v;
}

float evalPermutation(local const float4* colors, unsigned int permutation, ushort* start, ushort* end, float4 color_sum, constant float* alphaTable4, constant int* prods4, float weight) {
  float4 alphax_sum = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  int akku = 0;

  for (int i = 0; i < 16; i++) {
    const unsigned int bits = permutation >> (2 * i);

    alphax_sum += alphaTable4[hook(3, bits & 3)] * colors[hook(10, i)];
    akku += prods4[hook(4, bits & 3)];
  }

  float alpha2_sum = (akku >> 16);
  float beta2_sum = ((akku >> 8) & 0xff);
  float alphabeta_sum = ((akku >> 0) & 0xff);
  float4 betax_sum = weight * color_sum - alphax_sum;

  const float factor = 1.0f / (alpha2_sum * beta2_sum - alphabeta_sum * alphabeta_sum);

  float4 a = (alphax_sum * beta2_sum - betax_sum * alphabeta_sum) * factor;
  float4 b = (betax_sum * alpha2_sum - alphax_sum * alphabeta_sum) * factor;

  a = roundAndExpand(a, start);
  b = roundAndExpand(b, end);

  float4 e = a * a * alpha2_sum + b * b * beta2_sum + 2.0f * (a * b * alphabeta_sum - a * alphax_sum - b * betax_sum);

  return (1.0f / weight) * (e.x + e.y + e.z);
}

float evalPermutation3(local const float4* colors, unsigned int permutation, ushort* start, ushort* end, float4 color_sum, constant float* alphaTable3, constant int* prods3) {
  float4 alphax_sum = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  int akku = 0;

  for (int i = 0; i < 16; i++) {
    const unsigned int bits = permutation >> (2 * i);

    alphax_sum += alphaTable3[hook(5, bits & 3)] * colors[hook(10, i)];
    akku += prods3[hook(6, bits & 3)];
  }

  float alpha2_sum = (akku >> 16);
  float beta2_sum = ((akku >> 8) & 0xff);
  float alphabeta_sum = ((akku >> 0) & 0xff);
  float4 betax_sum = 4.0f * color_sum - alphax_sum;

  const float factor = 1.0f / (alpha2_sum * beta2_sum - alphabeta_sum * alphabeta_sum);

  float4 a = (alphax_sum * beta2_sum - betax_sum * alphabeta_sum) * factor;
  float4 b = (betax_sum * alpha2_sum - alphax_sum * alphabeta_sum) * factor;

  a = roundAndExpand(a, start);
  b = roundAndExpand(b, end);

  float4 e = a * a * alpha2_sum + b * b * beta2_sum + 2.0f * (a * b * alphabeta_sum - a * alphax_sum - b * betax_sum);

  return (0.25f) * (e.x + e.y + e.z);
}

uint4 evalAllPermutations(local const float4* colors, global const unsigned int* permutations, local float* errors, float4 color_sum, local unsigned int* s_permutations, constant float* alphaTable4, constant int* prods4, constant float* alphaTable3, constant int* prods3) {
  const int idx = get_local_id(0);

  unsigned int bestStart;
  unsigned int bestEnd;
  unsigned int bestPermutation;
  unsigned int temp;

  float bestError = 0x1.fffffep127f;

  for (int i = 0; i < 16; i++) {
    int pidx = idx + 64 * i;
    if (pidx >= 992)
      break;

    ushort start, end;
    unsigned int permutation = permutations[hook(0, pidx)];
    if (pidx < 160)
      s_permutations[hook(16, pidx)] = permutation;

    float error = evalPermutation(colors, permutation, &start, &end, color_sum, alphaTable4, prods4, 9.0f);
    if (error < bestError) {
      bestError = error;
      bestPermutation = permutation;
      bestStart = start;
      bestEnd = end;
    }
  }

  if (bestStart < bestEnd) {
    temp = bestEnd;
    bestEnd = bestStart;
    bestStart = temp;

    bestPermutation ^= 0x55555555;
  }

  for (int i = 0; i < 3; i++) {
    int pidx = idx + 64 * i;
    if (pidx >= 160)
      break;

    ushort start, end;
    unsigned int permutation = s_permutations[hook(16, pidx)];
    float error = evalPermutation(colors, permutation, &start, &end, color_sum, alphaTable3, prods3, 4.0f);
    if (error < bestError) {
      bestError = error;
      bestPermutation = permutation;
      bestStart = start;
      bestEnd = end;

      if (bestStart > bestEnd) {
        temp = bestEnd;
        bestEnd = bestStart;
        bestStart = temp;

        bestPermutation ^= (~bestPermutation >> 1) & 0x55555555;
      }
    }
  }

  errors[hook(17, idx)] = bestError;

  uint4 result = (uint4)(bestStart, bestEnd, bestPermutation, 0);
  return result;
}

int findMinError(local float* errors, local int* indices) {
  const int idx = get_local_id(0);

  indices[hook(18, idx)] = idx;

  for (int d = 64 / 2; d > 32; d >>= 1) {
    barrier(0x01);

    if (idx < d) {
      float err0 = errors[hook(17, idx)];
      float err1 = errors[hook(17, idx + d)];

      if (err1 < err0) {
        errors[hook(17, idx)] = err1;
        indices[hook(18, idx)] = indices[hook(18, idx + d)];
      }
    }
  }

  barrier(0x01);

  if (idx < 32) {
    if (errors[hook(17, idx + 32)] < errors[hook(17, idx)]) {
      errors[hook(17, idx)] = errors[hook(17, idx + 32)];
      indices[hook(18, idx)] = indices[hook(18, idx + 32)];
    }
    if (errors[hook(17, idx + 16)] < errors[hook(17, idx)]) {
      errors[hook(17, idx)] = errors[hook(17, idx + 16)];
      indices[hook(18, idx)] = indices[hook(18, idx + 16)];
    }
    if (errors[hook(17, idx + 8)] < errors[hook(17, idx)]) {
      errors[hook(17, idx)] = errors[hook(17, idx + 8)];
      indices[hook(18, idx)] = indices[hook(18, idx + 8)];
    }
    if (errors[hook(17, idx + 4)] < errors[hook(17, idx)]) {
      errors[hook(17, idx)] = errors[hook(17, idx + 4)];
      indices[hook(18, idx)] = indices[hook(18, idx + 4)];
    }
    if (errors[hook(17, idx + 2)] < errors[hook(17, idx)]) {
      errors[hook(17, idx)] = errors[hook(17, idx + 2)];
      indices[hook(18, idx)] = indices[hook(18, idx + 2)];
    }
    if (errors[hook(17, idx + 1)] < errors[hook(17, idx)]) {
      errors[hook(17, idx)] = errors[hook(17, idx + 1)];
      indices[hook(18, idx)] = indices[hook(18, idx + 1)];
    }
  }

  barrier(0x01);

  return indices[hook(18, 0)];
}

void saveBlockDXT1(unsigned int start, unsigned int end, unsigned int permutation, local int* xrefs, global uint2* result, int groupOffset) {
  const int bid = get_group_id(0) + groupOffset;

  if (start == end) {
    permutation = 0;
  }

  unsigned int indices = 0;
  for (int i = 0; i < 16; i++) {
    int ref = xrefs[hook(15, i)];
    indices |= ((permutation >> (2 * ref)) & 3) << (2 * i);
  }

  result[hook(2, bid)].x = (end << 16) | start;

  result[hook(2, bid)].y = indices;
}

kernel void compress(global const unsigned int* permutations, global const unsigned int* image, global uint2* result, constant float* alphaTable4, constant int* prods4, constant float* alphaTable3, constant int* prods3, int groupOffset) {
  local float4 colors[16];
  local float4 sums[16];
  local int s_int[64];
  local float s_float[16 * 6];
  local unsigned int s_permutations[160];
  local int xrefs[16];

  const int idx = get_local_id(0);

  loadColorBlock(image, colors, sums, xrefs, s_float, groupOffset);

  barrier(0x01);

  uint4 best = evalAllPermutations(colors, permutations, s_float, sums[hook(9, 0)], s_permutations, alphaTable4, prods4, alphaTable3, prods3);

  const int minIdx = findMinError(s_float, s_int);

  barrier(0x01);

  if (idx == minIdx) {
    saveBlockDXT1(best.x, best.y, best.z, xrefs, result, groupOffset);
  }
}