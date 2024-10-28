//{"alphaTable3":16,"alphaTable4":14,"colors":3,"covariance":10,"errors":18,"image":1,"indices":19,"matrix":9,"permutations":0,"prods3":17,"prods4":15,"ranks":12,"result":2,"s_float":6,"s_int":5,"s_permutations":7,"sums":4,"temp":13,"values":11,"xrefs":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 firstEigenVector(local float* matrix) {
  float4 v = (float4)(1.0f, 1.0f, 1.0f, 0.0f);
  for (int i = 0; i < 8; i++) {
    float x = v.x * matrix[hook(9, 0)] + v.y * matrix[hook(9, 1)] + v.z * matrix[hook(9, 2)];
    float y = v.x * matrix[hook(9, 1)] + v.y * matrix[hook(9, 3)] + v.z * matrix[hook(9, 4)];
    float z = v.x * matrix[hook(9, 2)] + v.y * matrix[hook(9, 4)] + v.z * matrix[hook(9, 5)];
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

  sums[hook(4, idx)] = colors[hook(3, idx)];
  sums[hook(4, idx)] += sums[hook(4, idx ^ 8)];
  sums[hook(4, idx)] += sums[hook(4, idx ^ 4)];
  sums[hook(4, idx)] += sums[hook(4, idx ^ 2)];
  sums[hook(4, idx)] += sums[hook(4, idx ^ 1)];
}

float4 bestFitLine(local const float4* colors, float4 color_sum, local float* covariance) {
  const int idx = get_local_id(0);

  float4 diff = colors[hook(3, idx)] - color_sum * (1.0f / 16.0f);

  covariance[hook(10, 6 * idx + 0)] = diff.x * diff.x;
  covariance[hook(10, 6 * idx + 1)] = diff.x * diff.y;
  covariance[hook(10, 6 * idx + 2)] = diff.x * diff.z;
  covariance[hook(10, 6 * idx + 3)] = diff.y * diff.y;
  covariance[hook(10, 6 * idx + 4)] = diff.y * diff.z;
  covariance[hook(10, 6 * idx + 5)] = diff.z * diff.z;

  for (int d = 8; d > 0; d >>= 1) {
    if (idx < d) {
      covariance[hook(10, 6 * idx + 0)] += covariance[hook(10, 6 * (idx + d) + 0)];
      covariance[hook(10, 6 * idx + 1)] += covariance[hook(10, 6 * (idx + d) + 1)];
      covariance[hook(10, 6 * idx + 2)] += covariance[hook(10, 6 * (idx + d) + 2)];
      covariance[hook(10, 6 * idx + 3)] += covariance[hook(10, 6 * (idx + d) + 3)];
      covariance[hook(10, 6 * idx + 4)] += covariance[hook(10, 6 * (idx + d) + 4)];
      covariance[hook(10, 6 * idx + 5)] += covariance[hook(10, 6 * (idx + d) + 5)];
    }
  }

  return firstEigenVector(covariance);
}

void sortColors(local const float* values, local int* ranks) {
  const int tid = get_local_id(0);

  int rank = 0;

  for (int i = 0; i < 16; i++) {
    rank += (values[hook(11, i)] < values[hook(11, tid)]);
  }

  ranks[hook(12, tid)] = rank;

  for (int i = 0; i < 15; i++) {
    if (tid > i && ranks[hook(12, tid)] == ranks[hook(12, i)])
      ++ranks[hook(12, tid)];
  }
}

void loadColorBlock(global const unsigned int* image, local float4* colors, local float4* sums, local int* xrefs, local float* temp) {
  const int bid = get_group_id(0);
  const int idx = get_local_id(0);

  float4 tmp;

  if (idx < 16) {
    unsigned int c = image[hook(1, (bid) * 16 + idx)];

    colors[hook(3, idx)].x = ((c >> 0) & 0xFF) * (1.0f / 255.0f);
    colors[hook(3, idx)].y = ((c >> 8) & 0xFF) * (1.0f / 255.0f);
    colors[hook(3, idx)].z = ((c >> 16) & 0xFF) * (1.0f / 255.0f);

    colorSums(colors, sums);
    float4 axis = bestFitLine(colors, sums[hook(4, idx)], temp);

    temp[hook(13, idx)] = colors[hook(3, idx)].x * axis.x + colors[hook(3, idx)].y * axis.y + colors[hook(3, idx)].z * axis.z;

    sortColors(temp, xrefs);

    tmp = colors[hook(3, idx)];

    colors[hook(3, xrefs[ihook(8, idx))] = tmp;
  }
}

float4 roundAndExpand(float4 v, ushort* w) {
  ushort x = round(clamp(v.x, 0.0f, 1.0f) * 31.0f);
  ushort y = round(clamp(v.y, 0.0f, 1.0f) * 63.0f);
  ushort z = round(clamp(v.z, 0.0f, 1.0f) * 31.0f);

  *w = ((x << 11) | (y << 5) | z);
  v.x = x * 0.03227752766457f;
  v.y = y * 0.01583151765563f;
  v.z = z * 0.03227752766457f;
  return v;
}

float evalPermutation4(local const float4* colors, unsigned int permutation, ushort* start, ushort* end, float4 color_sum) {
  const float alphaTable4[4] = {9.0f, 0.0f, 6.0f, 3.0f};
  const int prods4[4] = {0x090000, 0x000900, 0x040102, 0x010402};

  float4 alphax_sum = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  int akku = 0;

  for (int i = 0; i < 16; i++) {
    const unsigned int bits = permutation >> (2 * i);

    alphax_sum += alphaTable4[hook(14, bits & 3)] * colors[hook(3, i)];
    akku += prods4[hook(15, bits & 3)];
  }

  float alpha2_sum = (akku >> 16);
  float beta2_sum = ((akku >> 8) & 0xff);
  float alphabeta_sum = ((akku >> 0) & 0xff);
  float4 betax_sum = 9.0f * color_sum - alphax_sum;

  const float factor = 1.0f / (alpha2_sum * beta2_sum - alphabeta_sum * alphabeta_sum);

  float4 a = (alphax_sum * beta2_sum - betax_sum * alphabeta_sum) * factor;
  float4 b = (betax_sum * alpha2_sum - alphax_sum * alphabeta_sum) * factor;

  a = roundAndExpand(a, start);
  b = roundAndExpand(b, end);

  float4 e = a * a * alpha2_sum + b * b * beta2_sum + 2.0f * (a * b * alphabeta_sum - a * alphax_sum - b * betax_sum);

  return (1.0f / 9.0f) * (e.x + e.y + e.z);
}

float evalPermutation3(local const float4* colors, unsigned int permutation, ushort* start, ushort* end, float4 color_sum) {
  const int prods3[4] = {0x040000, 0x000400, 0x040101, 0x010401};
  const float alphaTable3[4] = {4.0f, 0.0f, 2.0f, 2.0f};

  float4 alphax_sum = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  int akku = 0;

  for (int i = 0; i < 16; i++) {
    const unsigned int bits = permutation >> (2 * i);

    alphax_sum += alphaTable3[hook(16, bits & 3)] * colors[hook(3, i)];
    akku += prods3[hook(17, bits & 3)];
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

  return (1.0f / 4.0f) * (e.x + e.y + e.z);
}

uint4 evalAllPermutations(local const float4* colors, global const unsigned int* permutations, local float* errors, float4 color_sum, local unsigned int* s_permutations) {
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
      s_permutations[hook(7, pidx)] = permutation;

    float error = evalPermutation4(colors, permutation, &start, &end, color_sum);

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
    unsigned int permutation = s_permutations[hook(7, pidx)];
    float error = evalPermutation3(colors, permutation, &start, &end, color_sum);

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

  errors[hook(18, idx)] = bestError;

  uint4 result = (uint4)(bestStart, bestEnd, bestPermutation, 0);
  return result;
}

int findMinError(local float* errors, local int* indices) {
  const int idx = get_local_id(0);

  indices[hook(19, idx)] = idx;

  for (int d = 64 / 2; d > 32; d >>= 1) {
    barrier(0x01);

    if (idx < d) {
      float err0 = errors[hook(18, idx)];
      float err1 = errors[hook(18, idx + d)];

      if (err1 < err0) {
        errors[hook(18, idx)] = err1;
        indices[hook(19, idx)] = indices[hook(19, idx + d)];
      }
    }
  }

  barrier(0x01);

  if (idx < 32) {
    if (errors[hook(18, idx + 32)] < errors[hook(18, idx)]) {
      errors[hook(18, idx)] = errors[hook(18, idx + 32)];
      indices[hook(19, idx)] = indices[hook(19, idx + 32)];
    }
    if (errors[hook(18, idx + 16)] < errors[hook(18, idx)]) {
      errors[hook(18, idx)] = errors[hook(18, idx + 16)];
      indices[hook(19, idx)] = indices[hook(19, idx + 16)];
    }
    if (errors[hook(18, idx + 8)] < errors[hook(18, idx)]) {
      errors[hook(18, idx)] = errors[hook(18, idx + 8)];
      indices[hook(19, idx)] = indices[hook(19, idx + 8)];
    }
    if (errors[hook(18, idx + 4)] < errors[hook(18, idx)]) {
      errors[hook(18, idx)] = errors[hook(18, idx + 4)];
      indices[hook(19, idx)] = indices[hook(19, idx + 4)];
    }
    if (errors[hook(18, idx + 2)] < errors[hook(18, idx)]) {
      errors[hook(18, idx)] = errors[hook(18, idx + 2)];
      indices[hook(19, idx)] = indices[hook(19, idx + 2)];
    }
    if (errors[hook(18, idx + 1)] < errors[hook(18, idx)]) {
      errors[hook(18, idx)] = errors[hook(18, idx + 1)];
      indices[hook(19, idx)] = indices[hook(19, idx + 1)];
    }
  }

  barrier(0x01);

  return indices[hook(19, 0)];
}

void saveBlockDXT1(unsigned int start, unsigned int end, unsigned int permutation, local int* xrefs, global uint2* result) {
  const int bid = get_group_id(0);

  if (start == end) {
    permutation = 0;
  }

  unsigned int indices = 0;
  for (int i = 0; i < 16; i++) {
    int ref = xrefs[hook(8, i)];
    indices |= ((permutation >> (2 * ref)) & 3) << (2 * i);
  }

  result[hook(2, bid)].x = (end << 16) | start;

  result[hook(2, bid)].y = indices;
}

kernel void compress(global const unsigned int* permutations, global const unsigned int* image, global uint2* result, local float4* colors, local float4* sums, local int* s_int, local float* s_float, local unsigned int* s_permutations, local int* xrefs) {
  const int idx = get_local_id(0);

  loadColorBlock(image, colors, sums, xrefs, s_float);

  barrier(0x01);

  uint4 best = evalAllPermutations(colors, permutations, s_float, sums[hook(4, 0)], s_permutations);

  const int minIdx = findMinError(s_float, s_int);

  barrier(0x01);

  if (idx == minIdx) {
    saveBlockDXT1(best.x, best.y, best.z, xrefs, result);
  }
}