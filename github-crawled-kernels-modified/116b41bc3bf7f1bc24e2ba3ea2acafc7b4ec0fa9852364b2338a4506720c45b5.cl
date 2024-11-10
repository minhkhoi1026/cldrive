//{"A":4,"b":6,"c_DM":3,"c_DW":13,"data":7,"descriptor_base":21,"descriptors":0,"descriptors_step":1,"featureDir":11,"featureSize":10,"featureX":8,"featureY":9,"s_PATCH":12,"s_dx_bin":14,"s_dy_bin":15,"sdata1":16,"sdata2":17,"sdata3":18,"sdata4":19,"smem":20,"sqDesc":22,"src":2,"x":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int read_sumTex(image2d_t img, sampler_t sam, int2 coord, int rows, int cols, int elemPerRow) {
  return read_imageui(img, sam, coord).x;
}
uchar read_imgTex(image2d_t img, sampler_t sam, float2 coord, int rows, int cols, int elemPerRow) {
  return (uchar)read_imageui(img, sam, coord).x;
}
constant sampler_t sampler = 0 | 2 | 0x10;
float icvCalcHaarPatternSum_2(image2d_t sumTex, constant float2* src, int oldSize, int newSize, int y, int x, int rows, int cols, int elemPerRow) {
  float ratio = (float)newSize / oldSize;

  float d = 0;

  int2 dx1 = convert_int2(round(ratio * src[hook(2, 0)]));
  int2 dy1 = convert_int2(round(ratio * src[hook(2, 1)]));
  int2 dx2 = convert_int2(round(ratio * src[hook(2, 2)]));
  int2 dy2 = convert_int2(round(ratio * src[hook(2, 3)]));

  float t = 0;
  t += read_sumTex(sumTex, sampler, (int2)(x + dx1.x, y + dy1.x), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx1.x, y + dy2.x), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx2.x, y + dy1.x), rows, cols, elemPerRow);
  t += read_sumTex(sumTex, sampler, (int2)(x + dx2.x, y + dy2.x), rows, cols, elemPerRow);
  d += t * src[hook(2, 4)].x / ((dx2.x - dx1.x) * (dy2.x - dy1.x));

  t = 0;
  t += read_sumTex(sumTex, sampler, (int2)(x + dx1.y, y + dy1.y), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx1.y, y + dy2.y), rows, cols, elemPerRow);
  t -= read_sumTex(sumTex, sampler, (int2)(x + dx2.y, y + dy1.y), rows, cols, elemPerRow);
  t += read_sumTex(sumTex, sampler, (int2)(x + dx2.y, y + dy2.y), rows, cols, elemPerRow);
  d += t * src[hook(2, 4)].y / ((dx2.y - dx1.y) * (dy2.y - dy1.y));

  return (float)d;
}

__inline int calcSize(int octave, int layer) {
  const int HAAR_SIZE0 = 9;

  const int HAAR_SIZE_INC = 6;

  return (HAAR_SIZE0 + HAAR_SIZE_INC * layer) << octave;
}

float calcAxisAlignedDerivative(int plus1a_A, int plus1a_B, int plus1a_C, int plus1a_D, float plus1a_scale, int plus1b_A, int plus1b_B, int plus1b_C, int plus1b_D, float plus1b_scale, int minus2_A, int minus2_B, int minus2_C, int minus2_D, float minus2_scale) {
  float plus1a = plus1a_A - plus1a_B - plus1a_C + plus1a_D;
  float plus1b = plus1b_A - plus1b_B - plus1b_C + plus1b_D;
  float minus2 = minus2_A - minus2_B - minus2_C + minus2_D;

  return (plus1a / plus1a_scale - 2.0f * minus2 / minus2_scale + plus1b / plus1b_scale);
}

constant float c_DM[5] = {0, 0, 9, 9, 1};

bool within_check(image2d_t maskSumTex, int sum_i, int sum_j, int size, int rows, int cols, int step) {
  float ratio = (float)size / 9.0f;

  float d = 0;

  int dx1 = round(ratio * c_DM[hook(3, 0)]);
  int dy1 = round(ratio * c_DM[hook(3, 1)]);
  int dx2 = round(ratio * c_DM[hook(3, 2)]);
  int dy2 = round(ratio * c_DM[hook(3, 3)]);

  float t = 0;

  t += read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx1, sum_i + dy1), rows, cols, step);
  t -= read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx1, sum_i + dy2), rows, cols, step);
  t -= read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx2, sum_i + dy1), rows, cols, step);
  t += read_sumTex(maskSumTex, sampler, (int2)(sum_j + dx2, sum_i + dy2), rows, cols, step);

  d += t * c_DM[hook(3, 4)] / ((dx2 - dx1) * (dy2 - dy1));

  return (d >= 0.5f);
}

inline bool solve3x3_float(const float4* A, const float* b, float* x) {
  float det = A[hook(4, 0)].x * (A[hook(4, 1)].y * A[hook(4, 2)].z - A[hook(4, 1)].z * A[hook(4, 2)].y) - A[hook(4, 0)].y * (A[hook(4, 1)].x * A[hook(4, 2)].z - A[hook(4, 1)].z * A[hook(4, 2)].x) + A[hook(4, 0)].z * (A[hook(4, 1)].x * A[hook(4, 2)].y - A[hook(4, 1)].y * A[hook(4, 2)].x);

  if (det != 0) {
    float invdet = 1.0 / det;

    x[hook(5, 0)] = invdet * (b[hook(6, 0)] * (A[hook(4, 1)].y * A[hook(4, 2)].z - A[hook(4, 1)].z * A[hook(4, 2)].y) - A[hook(4, 0)].y * (b[hook(6, 1)] * A[hook(4, 2)].z - A[hook(4, 1)].z * b[hook(6, 2)]) + A[hook(4, 0)].z * (b[hook(6, 1)] * A[hook(4, 2)].y - A[hook(4, 1)].y * b[hook(6, 2)]));

    x[hook(5, 1)] = invdet * (A[hook(4, 0)].x * (b[hook(6, 1)] * A[hook(4, 2)].z - A[hook(4, 1)].z * b[hook(6, 2)]) - b[hook(6, 0)] * (A[hook(4, 1)].x * A[hook(4, 2)].z - A[hook(4, 1)].z * A[hook(4, 2)].x) + A[hook(4, 0)].z * (A[hook(4, 1)].x * b[hook(6, 2)] - b[hook(6, 1)] * A[hook(4, 2)].x));

    x[hook(5, 2)] = invdet * (A[hook(4, 0)].x * (A[hook(4, 1)].y * b[hook(6, 2)] - b[hook(6, 1)] * A[hook(4, 2)].y) - A[hook(4, 0)].y * (A[hook(4, 1)].x * b[hook(6, 2)] - b[hook(6, 1)] * A[hook(4, 2)].x) + b[hook(6, 0)] * (A[hook(4, 1)].x * A[hook(4, 2)].y - A[hook(4, 1)].y * A[hook(4, 2)].x));

    return true;
  }
  return false;
}
constant float c_aptX[113] = {-6, -5, -5, -5, -5, -5, -5, -5, -4, -4, -4, -4, -4, -4, -4, -4, -4, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 6};
constant float c_aptY[113] = {0, -3, -2, -1, 0, 1, 2, 3, -4, -3, -2, -1, 0, 1, 2, 3, 4, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, -4, -3, -2, -1, 0, 1, 2, 3, 4, -3, -2, -1, 0, 1, 2, 3, 0};
constant float c_aptW[113] = {0.001455130288377404f, 0.001707611023448408f, 0.002547456417232752f, 0.003238451667129993f, 0.0035081731621176f, 0.003238451667129993f, 0.002547456417232752f, 0.001707611023448408f, 0.002003900473937392f, 0.0035081731621176f, 0.005233579315245152f, 0.00665318313986063f, 0.00720730796456337f, 0.00665318313986063f, 0.005233579315245152f, 0.0035081731621176f, 0.002003900473937392f, 0.001707611023448408f, 0.0035081731621176f, 0.006141661666333675f, 0.009162282571196556f, 0.01164754293859005f, 0.01261763460934162f, 0.01164754293859005f, 0.009162282571196556f, 0.006141661666333675f, 0.0035081731621176f, 0.001707611023448408f, 0.002547456417232752f, 0.005233579315245152f, 0.009162282571196556f, 0.01366852037608624f, 0.01737609319388866f, 0.0188232995569706f, 0.01737609319388866f, 0.01366852037608624f, 0.009162282571196556f, 0.005233579315245152f, 0.002547456417232752f, 0.003238451667129993f, 0.00665318313986063f, 0.01164754293859005f, 0.01737609319388866f, 0.02208934165537357f, 0.02392910048365593f, 0.02208934165537357f, 0.01737609319388866f, 0.01164754293859005f, 0.00665318313986063f, 0.003238451667129993f, 0.001455130288377404f, 0.0035081731621176f, 0.00720730796456337f, 0.01261763460934162f, 0.0188232995569706f, 0.02392910048365593f, 0.02592208795249462f, 0.02392910048365593f, 0.0188232995569706f, 0.01261763460934162f, 0.00720730796456337f, 0.0035081731621176f, 0.001455130288377404f, 0.003238451667129993f, 0.00665318313986063f, 0.01164754293859005f, 0.01737609319388866f, 0.02208934165537357f, 0.02392910048365593f, 0.02208934165537357f, 0.01737609319388866f, 0.01164754293859005f, 0.00665318313986063f, 0.003238451667129993f, 0.002547456417232752f, 0.005233579315245152f, 0.009162282571196556f, 0.01366852037608624f, 0.01737609319388866f, 0.0188232995569706f, 0.01737609319388866f, 0.01366852037608624f, 0.009162282571196556f, 0.005233579315245152f, 0.002547456417232752f, 0.001707611023448408f, 0.0035081731621176f, 0.006141661666333675f, 0.009162282571196556f, 0.01164754293859005f, 0.01261763460934162f, 0.01164754293859005f, 0.009162282571196556f, 0.006141661666333675f, 0.0035081731621176f, 0.001707611023448408f, 0.002003900473937392f, 0.0035081731621176f, 0.005233579315245152f, 0.00665318313986063f, 0.00720730796456337f, 0.00665318313986063f, 0.005233579315245152f, 0.0035081731621176f, 0.002003900473937392f, 0.001707611023448408f, 0.002547456417232752f, 0.003238451667129993f, 0.0035081731621176f, 0.003238451667129993f, 0.002547456417232752f, 0.001707611023448408f, 0.001455130288377404f};

constant float2 c_NX[5] = {(float2)(0, 2), (float2)(0, 0), (float2)(2, 4), (float2)(4, 4), (float2)(-1, 1)};
constant float2 c_NY[5] = {(float2)(0, 0), (float2)(0, 2), (float2)(4, 4), (float2)(2, 4), (float2)(1, -1)};

void reduce_32_sum(volatile local float* data, volatile float* partial_reduction, int tid) {
  data[hook(7, tid)] = *partial_reduction;
  barrier(0x01);

  if (tid < 16) {
    data[hook(7, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(7, tid + 16)]);
  }
  barrier(0x01);
  if (tid < 8) {
    data[hook(7, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(7, tid + 8)]);
  }
  barrier(0x01);
  if (tid < 4) {
    data[hook(7, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(7, tid + 4)]);
  }
  barrier(0x01);
  if (tid < 2) {
    data[hook(7, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(7, tid + 2)]);
  }
  barrier(0x01);
  if (tid < 1) {
    data[hook(7, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(7, tid + 1)]);
  }
}

constant float c_DW[20 * 20] = {3.695352233989979e-006f, 8.444558261544444e-006f, 1.760426494001877e-005f, 3.34794785885606e-005f, 5.808438800158911e-005f, 9.193058212986216e-005f, 0.0001327334757661447f, 0.0001748319627949968f, 0.0002100782439811155f, 0.0002302826324012131f, 0.0002302826324012131f, 0.0002100782439811155f, 0.0001748319627949968f, 0.0001327334757661447f, 9.193058212986216e-005f, 5.808438800158911e-005f, 3.34794785885606e-005f, 1.760426494001877e-005f, 8.444558261544444e-006f, 3.695352233989979e-006f, 8.444558261544444e-006f, 1.929736572492402e-005f, 4.022897701361217e-005f, 7.650675252079964e-005f, 0.0001327334903180599f, 0.0002100782585330308f, 0.0003033203829545528f, 0.0003995231236331165f, 0.0004800673632416874f, 0.0005262381164357066f, 0.0005262381164357066f, 0.0004800673632416874f, 0.0003995231236331165f, 0.0003033203829545528f, 0.0002100782585330308f, 0.0001327334903180599f, 7.650675252079964e-005f, 4.022897701361217e-005f, 1.929736572492402e-005f, 8.444558261544444e-006f, 1.760426494001877e-005f, 4.022897701361217e-005f, 8.386484114453197e-005f, 0.0001594926579855382f, 0.0002767078403849155f, 0.0004379475140012801f, 0.0006323281559161842f, 0.0008328808471560478f, 0.001000790391117334f, 0.001097041997127235f, 0.001097041997127235f, 0.001000790391117334f, 0.0008328808471560478f, 0.0006323281559161842f, 0.0004379475140012801f, 0.0002767078403849155f, 0.0001594926579855382f, 8.386484114453197e-005f, 4.022897701361217e-005f, 1.760426494001877e-005f, 3.34794785885606e-005f, 7.650675252079964e-005f, 0.0001594926579855382f, 0.0003033203247468919f, 0.0005262380582280457f, 0.0008328807889483869f, 0.001202550483867526f, 0.001583957928232849f, 0.001903285388834775f, 0.002086334861814976f, 0.002086334861814976f, 0.001903285388834775f, 0.001583957928232849f, 0.001202550483867526f, 0.0008328807889483869f, 0.0005262380582280457f, 0.0003033203247468919f, 0.0001594926579855382f, 7.650675252079964e-005f, 3.34794785885606e-005f, 5.808438800158911e-005f, 0.0001327334903180599f, 0.0002767078403849155f, 0.0005262380582280457f, 0.0009129836107604206f, 0.001444985857233405f, 0.002086335094645619f, 0.002748048631474376f, 0.00330205773934722f, 0.003619635012000799f, 0.003619635012000799f, 0.00330205773934722f, 0.002748048631474376f, 0.002086335094645619f, 0.001444985857233405f, 0.0009129836107604206f, 0.0005262380582280457f, 0.0002767078403849155f, 0.0001327334903180599f, 5.808438800158911e-005f, 9.193058212986216e-005f, 0.0002100782585330308f, 0.0004379475140012801f, 0.0008328807889483869f, 0.001444985857233405f,  0.002286989474669099f, 0.00330205773934722f,  0.004349356517195702f, 0.00522619066759944f, 0.005728822201490402f, 0.005728822201490402f, 0.00522619066759944f, 0.004349356517195702f, 0.00330205773934722f,  0.002286989474669099f, 0.001444985857233405f,  0.0008328807889483869f, 0.0004379475140012801f, 0.0002100782585330308f, 9.193058212986216e-005f, 0.0001327334757661447f, 0.0003033203829545528f,  0.0006323281559161842f, 0.001202550483867526f,  0.002086335094645619f,  0.00330205773934722f,   0.004767658654600382f, 0.006279794964939356f, 0.007545807864516974f, 0.008271530270576477f, 0.008271530270576477f, 0.007545807864516974f, 0.006279794964939356f, 0.004767658654600382f, 0.00330205773934722f,   0.002086335094645619f,  0.001202550483867526f,  0.0006323281559161842f, 0.0003033203829545528f,  0.0001327334757661447f, 0.0001748319627949968f,  0.0003995231236331165f,  0.0008328808471560478f,  0.001583957928232849f,  0.002748048631474376f,  0.004349356517195702f,  0.006279794964939356f,  0.008271529339253902f,  0.009939077310264111f, 0.01089497376233339f,  0.01089497376233339f,  0.009939077310264111f, 0.008271529339253902f,  0.006279794964939356f,  0.004349356517195702f,  0.002748048631474376f,  0.001583957928232849f,  0.0008328808471560478f,  0.0003995231236331165f,  0.0001748319627949968f,  0.0002100782439811155f,  0.0004800673632416874f,  0.001000790391117334f,   0.001903285388834775f,   0.00330205773934722f,   0.00522619066759944f,   0.007545807864516974f,  0.009939077310264111f,  0.01194280479103327f,   0.01309141051024199f,   0.01309141051024199f,   0.01194280479103327f,   0.009939077310264111f,  0.007545807864516974f,  0.00522619066759944f,   0.00330205773934722f,   0.001903285388834775f,   0.001000790391117334f,   0.0004800673632416874f,  0.0002100782439811155f,  0.0002302826324012131f,  0.0005262381164357066f,  0.001097041997127235f,   0.002086334861814976f,  0.003619635012000799f,   0.005728822201490402f,   0.008271530270576477f,  0.01089497376233339f,   0.01309141051024199f,   0.01435048412531614f,   0.01435048412531614f,   0.01309141051024199f,   0.01089497376233339f,   0.008271530270576477f,  0.005728822201490402f,   0.003619635012000799f,   0.002086334861814976f,  0.001097041997127235f,   0.0005262381164357066f,  0.0002302826324012131f,
                                0.0002302826324012131f,  0.0005262381164357066f,  0.001097041997127235f,   0.002086334861814976f,  0.003619635012000799f,   0.005728822201490402f,   0.008271530270576477f,  0.01089497376233339f,   0.01309141051024199f,   0.01435048412531614f,   0.01435048412531614f,   0.01309141051024199f,   0.01089497376233339f,   0.008271530270576477f,  0.005728822201490402f,   0.003619635012000799f,   0.002086334861814976f,  0.001097041997127235f,   0.0005262381164357066f,  0.0002302826324012131f,  0.0002100782439811155f,  0.0004800673632416874f,  0.001000790391117334f,   0.001903285388834775f,   0.00330205773934722f,   0.00522619066759944f,   0.007545807864516974f,  0.009939077310264111f,  0.01194280479103327f,   0.01309141051024199f,   0.01309141051024199f,   0.01194280479103327f,   0.009939077310264111f,  0.007545807864516974f,  0.00522619066759944f,   0.00330205773934722f,   0.001903285388834775f,   0.001000790391117334f,   0.0004800673632416874f,  0.0002100782439811155f,  0.0001748319627949968f,  0.0003995231236331165f,  0.0008328808471560478f,  0.001583957928232849f,  0.002748048631474376f,  0.004349356517195702f,  0.006279794964939356f,  0.008271529339253902f,  0.009939077310264111f, 0.01089497376233339f,  0.01089497376233339f,  0.009939077310264111f, 0.008271529339253902f,  0.006279794964939356f,  0.004349356517195702f,  0.002748048631474376f,  0.001583957928232849f,  0.0008328808471560478f,  0.0003995231236331165f,  0.0001748319627949968f,  0.0001327334757661447f, 0.0003033203829545528f,  0.0006323281559161842f, 0.001202550483867526f,  0.002086335094645619f,  0.00330205773934722f,   0.004767658654600382f, 0.006279794964939356f, 0.007545807864516974f, 0.008271530270576477f, 0.008271530270576477f, 0.007545807864516974f, 0.006279794964939356f, 0.004767658654600382f, 0.00330205773934722f,   0.002086335094645619f,  0.001202550483867526f,  0.0006323281559161842f, 0.0003033203829545528f,  0.0001327334757661447f, 9.193058212986216e-005f, 0.0002100782585330308f, 0.0004379475140012801f, 0.0008328807889483869f, 0.001444985857233405f,  0.002286989474669099f, 0.00330205773934722f,  0.004349356517195702f, 0.00522619066759944f, 0.005728822201490402f, 0.005728822201490402f, 0.00522619066759944f, 0.004349356517195702f, 0.00330205773934722f,  0.002286989474669099f, 0.001444985857233405f,  0.0008328807889483869f, 0.0004379475140012801f, 0.0002100782585330308f, 9.193058212986216e-005f, 5.808438800158911e-005f, 0.0001327334903180599f, 0.0002767078403849155f, 0.0005262380582280457f, 0.0009129836107604206f, 0.001444985857233405f, 0.002086335094645619f, 0.002748048631474376f, 0.00330205773934722f, 0.003619635012000799f, 0.003619635012000799f, 0.00330205773934722f, 0.002748048631474376f, 0.002086335094645619f, 0.001444985857233405f, 0.0009129836107604206f, 0.0005262380582280457f, 0.0002767078403849155f, 0.0001327334903180599f, 5.808438800158911e-005f, 3.34794785885606e-005f, 7.650675252079964e-005f, 0.0001594926579855382f, 0.0003033203247468919f, 0.0005262380582280457f, 0.0008328807889483869f, 0.001202550483867526f, 0.001583957928232849f, 0.001903285388834775f, 0.002086334861814976f, 0.002086334861814976f, 0.001903285388834775f, 0.001583957928232849f, 0.001202550483867526f, 0.0008328807889483869f, 0.0005262380582280457f, 0.0003033203247468919f, 0.0001594926579855382f, 7.650675252079964e-005f, 3.34794785885606e-005f, 1.760426494001877e-005f, 4.022897701361217e-005f, 8.386484114453197e-005f, 0.0001594926579855382f, 0.0002767078403849155f, 0.0004379475140012801f, 0.0006323281559161842f, 0.0008328808471560478f, 0.001000790391117334f, 0.001097041997127235f, 0.001097041997127235f, 0.001000790391117334f, 0.0008328808471560478f, 0.0006323281559161842f, 0.0004379475140012801f, 0.0002767078403849155f, 0.0001594926579855382f, 8.386484114453197e-005f, 4.022897701361217e-005f, 1.760426494001877e-005f, 8.444558261544444e-006f, 1.929736572492402e-005f, 4.022897701361217e-005f, 7.650675252079964e-005f, 0.0001327334903180599f, 0.0002100782585330308f, 0.0003033203829545528f, 0.0003995231236331165f, 0.0004800673632416874f, 0.0005262381164357066f, 0.0005262381164357066f, 0.0004800673632416874f, 0.0003995231236331165f, 0.0003033203829545528f, 0.0002100782585330308f, 0.0001327334903180599f, 7.650675252079964e-005f, 4.022897701361217e-005f, 1.929736572492402e-005f, 8.444558261544444e-006f, 3.695352233989979e-006f, 8.444558261544444e-006f, 1.760426494001877e-005f, 3.34794785885606e-005f, 5.808438800158911e-005f, 9.193058212986216e-005f, 0.0001327334757661447f, 0.0001748319627949968f, 0.0002100782439811155f, 0.0002302826324012131f, 0.0002302826324012131f, 0.0002100782439811155f, 0.0001748319627949968f, 0.0001327334757661447f, 9.193058212986216e-005f, 5.808438800158911e-005f, 3.34794785885606e-005f, 1.760426494001877e-005f, 8.444558261544444e-006f, 3.695352233989979e-006f};

inline uchar readerGet(image2d_t src, const float centerX, const float centerY, const float win_offset, const float cos_dir, const float sin_dir, int i, int j, int rows, int cols, int elemPerRow) {
  float pixel_x = centerX + (win_offset + j) * cos_dir + (win_offset + i) * sin_dir;
  float pixel_y = centerY - (win_offset + j) * sin_dir + (win_offset + i) * cos_dir;
  return read_imgTex(src, sampler, (float2)(pixel_x, pixel_y), rows, cols, elemPerRow);
}

inline float linearFilter(image2d_t src, const float centerX, const float centerY, const float win_offset, const float cos_dir, const float sin_dir, float y, float x, int rows, int cols, int elemPerRow) {
  x -= 0.5f;
  y -= 0.5f;

  float out = 0.0f;

  const int x1 = round(x);
  const int y1 = round(y);
  const int x2 = x1 + 1;
  const int y2 = y1 + 1;

  uchar src_reg = readerGet(src, centerX, centerY, win_offset, cos_dir, sin_dir, y1, x1, rows, cols, elemPerRow);
  out = out + src_reg * ((x2 - x) * (y2 - y));

  src_reg = readerGet(src, centerX, centerY, win_offset, cos_dir, sin_dir, y1, x2, rows, cols, elemPerRow);
  out = out + src_reg * ((x - x1) * (y2 - y));

  src_reg = readerGet(src, centerX, centerY, win_offset, cos_dir, sin_dir, y2, x1, rows, cols, elemPerRow);
  out = out + src_reg * ((x2 - x) * (y - y1));

  src_reg = readerGet(src, centerX, centerY, win_offset, cos_dir, sin_dir, y2, x2, rows, cols, elemPerRow);
  out = out + src_reg * ((x - x1) * (y - y1));

  return out;
}

void calc_dx_dy(image2d_t imgTex, volatile local float* s_dx_bin, volatile local float* s_dy_bin, volatile local float* s_PATCH, global const float* featureX, global const float* featureY, global const float* featureSize, global const float* featureDir, int rows, int cols, int elemPerRow) {
  const float centerX = featureX[hook(8, get_group_id(0))];
  const float centerY = featureY[hook(9, get_group_id(0))];
  const float size = featureSize[hook(10, get_group_id(0))];
  float descriptor_dir = 360.0f - featureDir[hook(11, get_group_id(0))];
  if (fabs(descriptor_dir - 360.0f) < 0x1.0p-23f) {
    descriptor_dir = 0.0f;
  }

  descriptor_dir *= (float)(3.14159265f / 180.0f);

  const float s = size * 1.2f / 9.0f;

  const int win_size = (int)((20 + 1) * s);

  float sin_dir;
  float cos_dir;
  sin_dir = sincos(descriptor_dir, &cos_dir);

  const float win_offset = -(float)(win_size - 1) / 2;

  const int xBlock = (get_group_id(1) & 3);
  const int yBlock = (get_group_id(1) >> 2);
  const int xIndex = xBlock * 5 + get_local_id(0);
  const int yIndex = yBlock * 5 + get_local_id(1);

  const float icoo = ((float)yIndex / (20 + 1)) * win_size;
  const float jcoo = ((float)xIndex / (20 + 1)) * win_size;

  s_PATCH[hook(12, get_local_id(1) * 6 + get_local_id(0))] = linearFilter(imgTex, centerX, centerY, win_offset, cos_dir, sin_dir, icoo, jcoo, rows, cols, elemPerRow);

  barrier(0x01);

  if (get_local_id(0) < 5 && get_local_id(1) < 5) {
    const int tid = get_local_id(1) * 5 + get_local_id(0);

    const float dw = c_DW[hook(13, yIndex * 20 + xIndex)];

    const float vx = (s_PATCH[hook(12, get_local_id(1) * 6 + get_local_id(0) + 1)] - s_PATCH[hook(12, get_local_id(1) * 6 + get_local_id(0))] + s_PATCH[hook(12, (get_local_id(1) + 1) * 6 + get_local_id(0) + 1)] - s_PATCH[hook(12, (get_local_id(1) + 1) * 6 + get_local_id(0))]) * dw;
    const float vy = (s_PATCH[hook(12, (get_local_id(1) + 1) * 6 + get_local_id(0))] - s_PATCH[hook(12, get_local_id(1) * 6 + get_local_id(0))] + s_PATCH[hook(12, (get_local_id(1) + 1) * 6 + get_local_id(0) + 1)] - s_PATCH[hook(12, get_local_id(1) * 6 + get_local_id(0) + 1)]) * dw;
    s_dx_bin[hook(14, tid)] = vx;
    s_dy_bin[hook(15, tid)] = vy;
  }
}
void reduce_sum25(volatile local float* sdata1, volatile local float* sdata2, volatile local float* sdata3, volatile local float* sdata4, int tid) {
  if (tid < 9) {
    sdata1[hook(16, tid)] += sdata1[hook(16, tid + 16)];
    sdata2[hook(17, tid)] += sdata2[hook(17, tid + 16)];
    sdata3[hook(18, tid)] += sdata3[hook(18, tid + 16)];
    sdata4[hook(19, tid)] += sdata4[hook(19, tid + 16)];
  }
  barrier(0x01);
  if (tid < 8) {
    sdata1[hook(16, tid)] += sdata1[hook(16, tid + 8)];
    sdata2[hook(17, tid)] += sdata2[hook(17, tid + 8)];
    sdata3[hook(18, tid)] += sdata3[hook(18, tid + 8)];
    sdata4[hook(19, tid)] += sdata4[hook(19, tid + 8)];
  }
  barrier(0x01);
  if (tid < 4) {
    sdata1[hook(16, tid)] += sdata1[hook(16, tid + 4)];
    sdata2[hook(17, tid)] += sdata2[hook(17, tid + 4)];
    sdata3[hook(18, tid)] += sdata3[hook(18, tid + 4)];
    sdata4[hook(19, tid)] += sdata4[hook(19, tid + 4)];
  }
  barrier(0x01);
  if (tid < 2) {
    sdata1[hook(16, tid)] += sdata1[hook(16, tid + 2)];
    sdata2[hook(17, tid)] += sdata2[hook(17, tid + 2)];
    sdata3[hook(18, tid)] += sdata3[hook(18, tid + 2)];
    sdata4[hook(19, tid)] += sdata4[hook(19, tid + 2)];
  }
  barrier(0x01);
  if (tid < 1) {
    sdata1[hook(16, tid)] += sdata1[hook(16, tid + 1)];
    sdata2[hook(17, tid)] += sdata2[hook(17, tid + 1)];
    sdata3[hook(18, tid)] += sdata3[hook(18, tid + 1)];
    sdata4[hook(19, tid)] += sdata4[hook(19, tid + 1)];
  }
}

void reduce_sum128(volatile local float* smem, int tid) {
  if (tid < 64) {
    smem[hook(20, tid)] += smem[hook(20, tid + 64)];
  }
  barrier(0x01);
  if (tid < 32) {
    smem[hook(20, tid)] += smem[hook(20, tid + 32)];
  }
  barrier(0x01);
  if (tid < 16) {
    smem[hook(20, tid)] += smem[hook(20, tid + 16)];
  }
  barrier(0x01);
  if (tid < 8) {
    smem[hook(20, tid)] += smem[hook(20, tid + 8)];
  }
  barrier(0x01);
  if (tid < 4) {
    smem[hook(20, tid)] += smem[hook(20, tid + 4)];
  }
  barrier(0x01);
  if (tid < 2) {
    smem[hook(20, tid)] += smem[hook(20, tid + 2)];
  }
  barrier(0x01);
  if (tid < 1) {
    smem[hook(20, tid)] += smem[hook(20, tid + 1)];
  }
}

void reduce_sum64(volatile local float* smem, int tid) {
  if (tid < 32) {
    smem[hook(20, tid)] += smem[hook(20, tid + 32)];
  }
  barrier(0x01);
  if (tid < 16) {
    smem[hook(20, tid)] += smem[hook(20, tid + 16)];
  }
  barrier(0x01);
  if (tid < 8) {
    smem[hook(20, tid)] += smem[hook(20, tid + 8)];
  }
  barrier(0x01);
  if (tid < 4) {
    smem[hook(20, tid)] += smem[hook(20, tid + 4)];
  }
  barrier(0x01);
  if (tid < 2) {
    smem[hook(20, tid)] += smem[hook(20, tid + 2)];
  }
  barrier(0x01);
  if (tid < 1) {
    smem[hook(20, tid)] += smem[hook(20, tid + 1)];
  }
}

kernel void normalize_descriptors64(global float* descriptors, int descriptors_step) {
  descriptors_step /= sizeof(*descriptors);

  global float* descriptor_base = descriptors + descriptors_step * get_group_id(0);

  volatile local float sqDesc[64];
  const float lookup = descriptor_base[hook(21, get_local_id(0))];
  sqDesc[hook(22, get_local_id(0))] = lookup * lookup;
  barrier(0x01);

  reduce_sum64(sqDesc, get_local_id(0));
  barrier(0x01);

  volatile local float len;
  if (get_local_id(0) == 0) {
    len = sqrt(sqDesc[hook(22, 0)]);
  }
  barrier(0x01);

  descriptor_base[hook(21, get_local_id(0))] = lookup / len;
}