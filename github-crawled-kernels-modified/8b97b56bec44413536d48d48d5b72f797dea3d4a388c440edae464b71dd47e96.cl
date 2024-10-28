//{"A":12,"b":14,"c_DW":21,"data":15,"descriptors":8,"descriptors_block":32,"descriptors_offset":10,"descriptors_step":9,"featureDir":19,"featureSize":18,"featureX":16,"featureY":17,"imgTex":0,"img_cols":4,"img_offset":2,"img_rows":3,"img_step":1,"keypoints":5,"keypoints_offset":7,"keypoints_step":6,"s_PATCH":20,"s_dx_bin":22,"s_dy_bin":23,"sdata1":24,"sdata2":25,"sdata3":26,"sdata4":27,"sdx":29,"sdxabs":28,"sdy":31,"sdyabs":30,"sumTex":11,"x":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__inline unsigned int read_sumTex_(global unsigned int* sumTex, int sum_step, int img_rows, int img_cols, int2 coord) {
  int x = clamp(coord.x, 0, img_cols);
  int y = clamp(coord.y, 0, img_rows);
  return sumTex[hook(11, sum_step * y + x)];
}

__inline uchar read_imgTex_(global uchar* imgTex, int img_step, int img_rows, int img_cols, float2 coord) {
  int x = clamp(convert_int_rte(coord.x), 0, img_cols - 1);
  int y = clamp(convert_int_rte(coord.y), 0, img_rows - 1);
  return imgTex[hook(0, img_step * y + x)];
}
constant sampler_t sampler = 0 | 2 | 0x10;
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

inline bool solve3x3_float(const float4* A, const float* b, float* x) {
  float det = A[hook(12, 0)].x * (A[hook(12, 1)].y * A[hook(12, 2)].z - A[hook(12, 1)].z * A[hook(12, 2)].y) - A[hook(12, 0)].y * (A[hook(12, 1)].x * A[hook(12, 2)].z - A[hook(12, 1)].z * A[hook(12, 2)].x) + A[hook(12, 0)].z * (A[hook(12, 1)].x * A[hook(12, 2)].y - A[hook(12, 1)].y * A[hook(12, 2)].x);

  if (det != 0) {
    float invdet = 1.0f / det;

    x[hook(13, 0)] = invdet * (b[hook(14, 0)] * (A[hook(12, 1)].y * A[hook(12, 2)].z - A[hook(12, 1)].z * A[hook(12, 2)].y) - A[hook(12, 0)].y * (b[hook(14, 1)] * A[hook(12, 2)].z - A[hook(12, 1)].z * b[hook(14, 2)]) + A[hook(12, 0)].z * (b[hook(14, 1)] * A[hook(12, 2)].y - A[hook(12, 1)].y * b[hook(14, 2)]));

    x[hook(13, 1)] = invdet * (A[hook(12, 0)].x * (b[hook(14, 1)] * A[hook(12, 2)].z - A[hook(12, 1)].z * b[hook(14, 2)]) - b[hook(14, 0)] * (A[hook(12, 1)].x * A[hook(12, 2)].z - A[hook(12, 1)].z * A[hook(12, 2)].x) + A[hook(12, 0)].z * (A[hook(12, 1)].x * b[hook(14, 2)] - b[hook(14, 1)] * A[hook(12, 2)].x));

    x[hook(13, 2)] = invdet * (A[hook(12, 0)].x * (A[hook(12, 1)].y * b[hook(14, 2)] - b[hook(14, 1)] * A[hook(12, 2)].y) - A[hook(12, 0)].y * (A[hook(12, 1)].x * b[hook(14, 2)] - b[hook(14, 1)] * A[hook(12, 2)].x) + b[hook(14, 0)] * (A[hook(12, 1)].x * A[hook(12, 2)].y - A[hook(12, 1)].y * A[hook(12, 2)].x));

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
  data[hook(15, tid)] = *partial_reduction;
  barrier(0x01);

  if (tid < 16) {
    data[hook(15, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(15, tid + 16)]);
  }
  barrier(0x01);
  if (tid < 8) {
    data[hook(15, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(15, tid + 8)]);
  }
  barrier(0x01);
  if (tid < 4) {
    data[hook(15, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(15, tid + 4)]);
  }
  barrier(0x01);
  if (tid < 2) {
    data[hook(15, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(15, tid + 2)]);
  }
  barrier(0x01);
  if (tid < 1) {
    data[hook(15, tid)] = *partial_reduction = (*partial_reduction) + (data[hook(15, tid + 1)]);
  }
}

constant float c_DW[20 * 20] = {3.695352233989979e-006f, 8.444558261544444e-006f, 1.760426494001877e-005f, 3.34794785885606e-005f, 5.808438800158911e-005f, 9.193058212986216e-005f, 0.0001327334757661447f, 0.0001748319627949968f, 0.0002100782439811155f, 0.0002302826324012131f, 0.0002302826324012131f, 0.0002100782439811155f, 0.0001748319627949968f, 0.0001327334757661447f, 9.193058212986216e-005f, 5.808438800158911e-005f, 3.34794785885606e-005f, 1.760426494001877e-005f, 8.444558261544444e-006f, 3.695352233989979e-006f, 8.444558261544444e-006f, 1.929736572492402e-005f, 4.022897701361217e-005f, 7.650675252079964e-005f, 0.0001327334903180599f, 0.0002100782585330308f, 0.0003033203829545528f, 0.0003995231236331165f, 0.0004800673632416874f, 0.0005262381164357066f, 0.0005262381164357066f, 0.0004800673632416874f, 0.0003995231236331165f, 0.0003033203829545528f, 0.0002100782585330308f, 0.0001327334903180599f, 7.650675252079964e-005f, 4.022897701361217e-005f, 1.929736572492402e-005f, 8.444558261544444e-006f, 1.760426494001877e-005f, 4.022897701361217e-005f, 8.386484114453197e-005f, 0.0001594926579855382f, 0.0002767078403849155f, 0.0004379475140012801f, 0.0006323281559161842f, 0.0008328808471560478f, 0.001000790391117334f, 0.001097041997127235f, 0.001097041997127235f, 0.001000790391117334f, 0.0008328808471560478f, 0.0006323281559161842f, 0.0004379475140012801f, 0.0002767078403849155f, 0.0001594926579855382f, 8.386484114453197e-005f, 4.022897701361217e-005f, 1.760426494001877e-005f, 3.34794785885606e-005f, 7.650675252079964e-005f, 0.0001594926579855382f, 0.0003033203247468919f, 0.0005262380582280457f, 0.0008328807889483869f, 0.001202550483867526f, 0.001583957928232849f, 0.001903285388834775f, 0.002086334861814976f, 0.002086334861814976f, 0.001903285388834775f, 0.001583957928232849f, 0.001202550483867526f, 0.0008328807889483869f, 0.0005262380582280457f, 0.0003033203247468919f, 0.0001594926579855382f, 7.650675252079964e-005f, 3.34794785885606e-005f, 5.808438800158911e-005f, 0.0001327334903180599f, 0.0002767078403849155f, 0.0005262380582280457f, 0.0009129836107604206f, 0.001444985857233405f, 0.002086335094645619f, 0.002748048631474376f, 0.00330205773934722f, 0.003619635012000799f, 0.003619635012000799f, 0.00330205773934722f, 0.002748048631474376f, 0.002086335094645619f, 0.001444985857233405f, 0.0009129836107604206f, 0.0005262380582280457f, 0.0002767078403849155f, 0.0001327334903180599f, 5.808438800158911e-005f, 9.193058212986216e-005f, 0.0002100782585330308f, 0.0004379475140012801f, 0.0008328807889483869f, 0.001444985857233405f,  0.002286989474669099f, 0.00330205773934722f,  0.004349356517195702f, 0.00522619066759944f, 0.005728822201490402f, 0.005728822201490402f, 0.00522619066759944f, 0.004349356517195702f, 0.00330205773934722f,  0.002286989474669099f, 0.001444985857233405f,  0.0008328807889483869f, 0.0004379475140012801f, 0.0002100782585330308f, 9.193058212986216e-005f, 0.0001327334757661447f, 0.0003033203829545528f,  0.0006323281559161842f, 0.001202550483867526f,  0.002086335094645619f,  0.00330205773934722f,   0.004767658654600382f, 0.006279794964939356f, 0.007545807864516974f, 0.008271530270576477f, 0.008271530270576477f, 0.007545807864516974f, 0.006279794964939356f, 0.004767658654600382f, 0.00330205773934722f,   0.002086335094645619f,  0.001202550483867526f,  0.0006323281559161842f, 0.0003033203829545528f,  0.0001327334757661447f, 0.0001748319627949968f,  0.0003995231236331165f,  0.0008328808471560478f,  0.001583957928232849f,  0.002748048631474376f,  0.004349356517195702f,  0.006279794964939356f,  0.008271529339253902f,  0.009939077310264111f, 0.01089497376233339f,  0.01089497376233339f,  0.009939077310264111f, 0.008271529339253902f,  0.006279794964939356f,  0.004349356517195702f,  0.002748048631474376f,  0.001583957928232849f,  0.0008328808471560478f,  0.0003995231236331165f,  0.0001748319627949968f,  0.0002100782439811155f,  0.0004800673632416874f,  0.001000790391117334f,   0.001903285388834775f,   0.00330205773934722f,   0.00522619066759944f,   0.007545807864516974f,  0.009939077310264111f,  0.01194280479103327f,   0.01309141051024199f,   0.01309141051024199f,   0.01194280479103327f,   0.009939077310264111f,  0.007545807864516974f,  0.00522619066759944f,   0.00330205773934722f,   0.001903285388834775f,   0.001000790391117334f,   0.0004800673632416874f,  0.0002100782439811155f,  0.0002302826324012131f,  0.0005262381164357066f,  0.001097041997127235f,   0.002086334861814976f,  0.003619635012000799f,   0.005728822201490402f,   0.008271530270576477f,  0.01089497376233339f,   0.01309141051024199f,   0.01435048412531614f,   0.01435048412531614f,   0.01309141051024199f,   0.01089497376233339f,   0.008271530270576477f,  0.005728822201490402f,   0.003619635012000799f,   0.002086334861814976f,  0.001097041997127235f,   0.0005262381164357066f,  0.0002302826324012131f,
                                0.0002302826324012131f,  0.0005262381164357066f,  0.001097041997127235f,   0.002086334861814976f,  0.003619635012000799f,   0.005728822201490402f,   0.008271530270576477f,  0.01089497376233339f,   0.01309141051024199f,   0.01435048412531614f,   0.01435048412531614f,   0.01309141051024199f,   0.01089497376233339f,   0.008271530270576477f,  0.005728822201490402f,   0.003619635012000799f,   0.002086334861814976f,  0.001097041997127235f,   0.0005262381164357066f,  0.0002302826324012131f,  0.0002100782439811155f,  0.0004800673632416874f,  0.001000790391117334f,   0.001903285388834775f,   0.00330205773934722f,   0.00522619066759944f,   0.007545807864516974f,  0.009939077310264111f,  0.01194280479103327f,   0.01309141051024199f,   0.01309141051024199f,   0.01194280479103327f,   0.009939077310264111f,  0.007545807864516974f,  0.00522619066759944f,   0.00330205773934722f,   0.001903285388834775f,   0.001000790391117334f,   0.0004800673632416874f,  0.0002100782439811155f,  0.0001748319627949968f,  0.0003995231236331165f,  0.0008328808471560478f,  0.001583957928232849f,  0.002748048631474376f,  0.004349356517195702f,  0.006279794964939356f,  0.008271529339253902f,  0.009939077310264111f, 0.01089497376233339f,  0.01089497376233339f,  0.009939077310264111f, 0.008271529339253902f,  0.006279794964939356f,  0.004349356517195702f,  0.002748048631474376f,  0.001583957928232849f,  0.0008328808471560478f,  0.0003995231236331165f,  0.0001748319627949968f,  0.0001327334757661447f, 0.0003033203829545528f,  0.0006323281559161842f, 0.001202550483867526f,  0.002086335094645619f,  0.00330205773934722f,   0.004767658654600382f, 0.006279794964939356f, 0.007545807864516974f, 0.008271530270576477f, 0.008271530270576477f, 0.007545807864516974f, 0.006279794964939356f, 0.004767658654600382f, 0.00330205773934722f,   0.002086335094645619f,  0.001202550483867526f,  0.0006323281559161842f, 0.0003033203829545528f,  0.0001327334757661447f, 9.193058212986216e-005f, 0.0002100782585330308f, 0.0004379475140012801f, 0.0008328807889483869f, 0.001444985857233405f,  0.002286989474669099f, 0.00330205773934722f,  0.004349356517195702f, 0.00522619066759944f, 0.005728822201490402f, 0.005728822201490402f, 0.00522619066759944f, 0.004349356517195702f, 0.00330205773934722f,  0.002286989474669099f, 0.001444985857233405f,  0.0008328807889483869f, 0.0004379475140012801f, 0.0002100782585330308f, 9.193058212986216e-005f, 5.808438800158911e-005f, 0.0001327334903180599f, 0.0002767078403849155f, 0.0005262380582280457f, 0.0009129836107604206f, 0.001444985857233405f, 0.002086335094645619f, 0.002748048631474376f, 0.00330205773934722f, 0.003619635012000799f, 0.003619635012000799f, 0.00330205773934722f, 0.002748048631474376f, 0.002086335094645619f, 0.001444985857233405f, 0.0009129836107604206f, 0.0005262380582280457f, 0.0002767078403849155f, 0.0001327334903180599f, 5.808438800158911e-005f, 3.34794785885606e-005f, 7.650675252079964e-005f, 0.0001594926579855382f, 0.0003033203247468919f, 0.0005262380582280457f, 0.0008328807889483869f, 0.001202550483867526f, 0.001583957928232849f, 0.001903285388834775f, 0.002086334861814976f, 0.002086334861814976f, 0.001903285388834775f, 0.001583957928232849f, 0.001202550483867526f, 0.0008328807889483869f, 0.0005262380582280457f, 0.0003033203247468919f, 0.0001594926579855382f, 7.650675252079964e-005f, 3.34794785885606e-005f, 1.760426494001877e-005f, 4.022897701361217e-005f, 8.386484114453197e-005f, 0.0001594926579855382f, 0.0002767078403849155f, 0.0004379475140012801f, 0.0006323281559161842f, 0.0008328808471560478f, 0.001000790391117334f, 0.001097041997127235f, 0.001097041997127235f, 0.001000790391117334f, 0.0008328808471560478f, 0.0006323281559161842f, 0.0004379475140012801f, 0.0002767078403849155f, 0.0001594926579855382f, 8.386484114453197e-005f, 4.022897701361217e-005f, 1.760426494001877e-005f, 8.444558261544444e-006f, 1.929736572492402e-005f, 4.022897701361217e-005f, 7.650675252079964e-005f, 0.0001327334903180599f, 0.0002100782585330308f, 0.0003033203829545528f, 0.0003995231236331165f, 0.0004800673632416874f, 0.0005262381164357066f, 0.0005262381164357066f, 0.0004800673632416874f, 0.0003995231236331165f, 0.0003033203829545528f, 0.0002100782585330308f, 0.0001327334903180599f, 7.650675252079964e-005f, 4.022897701361217e-005f, 1.929736572492402e-005f, 8.444558261544444e-006f, 3.695352233989979e-006f, 8.444558261544444e-006f, 1.760426494001877e-005f, 3.34794785885606e-005f, 5.808438800158911e-005f, 9.193058212986216e-005f, 0.0001327334757661447f, 0.0001748319627949968f, 0.0002100782439811155f, 0.0002302826324012131f, 0.0002302826324012131f, 0.0002100782439811155f, 0.0001748319627949968f, 0.0001327334757661447f, 9.193058212986216e-005f, 5.808438800158911e-005f, 3.34794785885606e-005f, 1.760426494001877e-005f, 8.444558261544444e-006f, 3.695352233989979e-006f};

inline float linearFilter(global uchar* imgTex, int img_step, int img_offset, int img_rows, int img_cols, float centerX, float centerY, float win_offset, float cos_dir, float sin_dir, float y, float x) {
  float out = 0.0f;

  const int x1 = round(x);
  const int y1 = round(y);
  const int x2 = x1 + 1;
  const int y2 = y1 + 1;

  uchar src_reg = read_imgTex_(imgTex, img_step, img_rows, img_cols, (float2)(centerX + (win_offset + x1) * cos_dir + (win_offset + y1) * sin_dir, centerY - (win_offset + x1) * sin_dir + (win_offset + y1) * cos_dir));
  out = out + src_reg * ((x2 - x) * (y2 - y));

  src_reg = read_imgTex_(imgTex, img_step, img_rows, img_cols, (float2)(centerX + (win_offset + x2) * cos_dir + (win_offset + y1) * sin_dir, centerY - (win_offset + x2) * sin_dir + (win_offset + y1) * cos_dir));
  out = out + src_reg * ((x - x1) * (y2 - y));

  src_reg = read_imgTex_(imgTex, img_step, img_rows, img_cols, (float2)(centerX + (win_offset + x1) * cos_dir + (win_offset + y2) * sin_dir, centerY - (win_offset + x1) * sin_dir + (win_offset + y2) * cos_dir));
  out = out + src_reg * ((x2 - x) * (y - y1));

  src_reg = read_imgTex_(imgTex, img_step, img_rows, img_cols, (float2)(centerX + (win_offset + x2) * cos_dir + (win_offset + y2) * sin_dir, centerY - (win_offset + x2) * sin_dir + (win_offset + y2) * cos_dir));
  out = out + src_reg * ((x - x1) * (y - y1));

  return out;
}

inline float areaFilter(global uchar* imgTex, int img_step, int img_offset, int img_rows, int img_cols, float centerX, float centerY, float win_offset, float cos_dir, float sin_dir, float x, float y, float s) {
  float fsx1 = x * s;
  float fsx2 = fsx1 + s;

  int sx1 = convert_int_rtp(fsx1);
  int sx2 = convert_int_rtn(fsx2);

  float fsy1 = y * s;
  float fsy2 = fsy1 + s;

  int sy1 = convert_int_rtp(fsy1);
  int sy2 = convert_int_rtn(fsy2);

  float scale = 1.f / (s * s);
  float out = 0.f;

  for (int dy = sy1; dy < sy2; ++dy) {
    for (int dx = sx1; dx < sx2; ++dx)
      out = out + read_imgTex_(imgTex, img_step, img_rows, img_cols, (float2)(centerX + (win_offset + dx) * cos_dir + (win_offset + dy) * sin_dir, centerY - (win_offset + dx) * sin_dir + (win_offset + dy) * cos_dir)) * scale;

    if (sx1 > fsx1)
      out = out + read_imgTex_(imgTex, img_step, img_rows, img_cols, (float2)(centerX + (win_offset + (sx1 - 1)) * cos_dir + (win_offset + dy) * sin_dir, centerY - (win_offset + (sx1 - 1)) * sin_dir + (win_offset + dy) * cos_dir)) * ((sx1 - fsx1) * scale);

    if (sx2 < fsx2)
      out = out + read_imgTex_(imgTex, img_step, img_rows, img_cols, (float2)(centerX + (win_offset + sx2) * cos_dir + (win_offset + dy) * sin_dir, centerY - (win_offset + sx2) * sin_dir + (win_offset + dy) * cos_dir)) * ((fsx2 - sx2) * scale);
  }

  if (sy1 > fsy1)
    for (int dx = sx1; dx < sx2; ++dx)
      out = out + read_imgTex_(imgTex, img_step, img_rows, img_cols, (float2)(centerX + (win_offset + dx) * cos_dir + (win_offset + (sy1 - 1)) * sin_dir, centerY - (win_offset + dx) * sin_dir + (win_offset + (sy1 - 1)) * cos_dir)) * ((sy1 - fsy1) * scale);

  if (sy2 < fsy2)
    for (int dx = sx1; dx < sx2; ++dx)
      out = out + read_imgTex_(imgTex, img_step, img_rows, img_cols, (float2)(centerX + (win_offset + dx) * cos_dir + (win_offset + sy2) * sin_dir, centerY - (win_offset + dx) * sin_dir + (win_offset + sy2) * cos_dir)) * ((fsy2 - sy2) * scale);

  if ((sy1 > fsy1) && (sx1 > fsx1))
    out = out + read_imgTex_(imgTex, img_step, img_rows, img_cols, (float2)(centerX + (win_offset + (sx1 - 1)) * cos_dir + (win_offset + (sy1 - 1)) * sin_dir, centerY - (win_offset + (sx1 - 1)) * sin_dir + (win_offset + (sy1 - 1)) * cos_dir)) * ((sy1 - fsy1) * (sx1 - fsx1) * scale);

  if ((sy1 > fsy1) && (sx2 < fsx2))
    out = out + read_imgTex_(imgTex, img_step, img_rows, img_cols, (float2)(centerX + (win_offset + sx2) * cos_dir + (win_offset + (sy1 - 1)) * sin_dir, centerY - (win_offset + sx2) * sin_dir + (win_offset + (sy1 - 1)) * cos_dir)) * ((sy1 - fsy1) * (fsx2 - sx2) * scale);

  if ((sy2 < fsy2) && (sx2 < fsx2))
    out = out + read_imgTex_(imgTex, img_step, img_rows, img_cols, (float2)(centerX + (win_offset + sx2) * cos_dir + (win_offset + sy2) * sin_dir, centerY - (win_offset + sx2) * sin_dir + (win_offset + sy2) * cos_dir)) * ((fsy2 - sy2) * (fsx2 - sx2) * scale);

  if ((sy2 < fsy2) && (sx1 > fsx1))
    out = out + read_imgTex_(imgTex, img_step, img_rows, img_cols, (float2)(centerX + (win_offset + (sx1 - 1)) * cos_dir + (win_offset + sy2) * sin_dir, centerY - (win_offset + (sx1 - 1)) * sin_dir + (win_offset + sy2) * cos_dir)) * ((fsy2 - sy2) * (sx1 - fsx1) * scale);

  return out;
}

void calc_dx_dy(global uchar* imgTex, int img_step, int img_offset, int img_rows, int img_cols, volatile local float* s_dx_bin, volatile local float* s_dy_bin, volatile local float* s_PATCH, global const float* featureX, global const float* featureY, global const float* featureSize, global const float* featureDir) {
  const float centerX = featureX[hook(16, get_group_id(0))];
  const float centerY = featureY[hook(17, get_group_id(0))];
  const float size = featureSize[hook(18, get_group_id(0))];
  float descriptor_dir = 360.0f - featureDir[hook(19, get_group_id(0))];
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

  if (s > 1) {
    s_PATCH[hook(20, get_local_id(1) * 6 + get_local_id(0))] = areaFilter(imgTex, img_step, img_offset, img_rows, img_cols, centerX, centerY, win_offset, cos_dir, sin_dir, xIndex, yIndex, s);
  } else {
    s_PATCH[hook(20, get_local_id(1) * 6 + get_local_id(0))] = linearFilter(imgTex, img_step, img_offset, img_rows, img_cols, centerX, centerY, win_offset, cos_dir, sin_dir, icoo, jcoo);
  }

  barrier(0x01);

  if (get_local_id(0) < 5 && get_local_id(1) < 5) {
    const int tid = get_local_id(1) * 5 + get_local_id(0);

    const float dw = c_DW[hook(21, yIndex * 20 + xIndex)];

    const float vx = (s_PATCH[hook(20, get_local_id(1) * 6 + get_local_id(0) + 1)] - s_PATCH[hook(20, get_local_id(1) * 6 + get_local_id(0))] + s_PATCH[hook(20, (get_local_id(1) + 1) * 6 + get_local_id(0) + 1)] - s_PATCH[hook(20, (get_local_id(1) + 1) * 6 + get_local_id(0))]) * dw;
    const float vy = (s_PATCH[hook(20, (get_local_id(1) + 1) * 6 + get_local_id(0))] - s_PATCH[hook(20, get_local_id(1) * 6 + get_local_id(0))] + s_PATCH[hook(20, (get_local_id(1) + 1) * 6 + get_local_id(0) + 1)] - s_PATCH[hook(20, get_local_id(1) * 6 + get_local_id(0) + 1)]) * dw;
    s_dx_bin[hook(22, tid)] = vx;
    s_dy_bin[hook(23, tid)] = vy;
  }
}

void reduce_sum25(volatile local float* sdata1, volatile local float* sdata2, volatile local float* sdata3, volatile local float* sdata4, int tid) {
  if (tid < 9) {
    sdata1[hook(24, tid)] += sdata1[hook(24, tid + 16)];
    sdata2[hook(25, tid)] += sdata2[hook(25, tid + 16)];
    sdata3[hook(26, tid)] += sdata3[hook(26, tid + 16)];
    sdata4[hook(27, tid)] += sdata4[hook(27, tid + 16)];
  }
  barrier(0x01);
  if (tid < 8) {
    sdata1[hook(24, tid)] += sdata1[hook(24, tid + 8)];
    sdata2[hook(25, tid)] += sdata2[hook(25, tid + 8)];
    sdata3[hook(26, tid)] += sdata3[hook(26, tid + 8)];
    sdata4[hook(27, tid)] += sdata4[hook(27, tid + 8)];
  }
  barrier(0x01);
  if (tid < 4) {
    sdata1[hook(24, tid)] += sdata1[hook(24, tid + 4)];
    sdata2[hook(25, tid)] += sdata2[hook(25, tid + 4)];
    sdata3[hook(26, tid)] += sdata3[hook(26, tid + 4)];
    sdata4[hook(27, tid)] += sdata4[hook(27, tid + 4)];
  }
  barrier(0x01);
  if (tid < 2) {
    sdata1[hook(24, tid)] += sdata1[hook(24, tid + 2)];
    sdata2[hook(25, tid)] += sdata2[hook(25, tid + 2)];
    sdata3[hook(26, tid)] += sdata3[hook(26, tid + 2)];
    sdata4[hook(27, tid)] += sdata4[hook(27, tid + 2)];
  }
  barrier(0x01);
  if (tid < 1) {
    sdata1[hook(24, tid)] += sdata1[hook(24, tid + 1)];
    sdata2[hook(25, tid)] += sdata2[hook(25, tid + 1)];
    sdata3[hook(26, tid)] += sdata3[hook(26, tid + 1)];
    sdata4[hook(27, tid)] += sdata4[hook(27, tid + 1)];
  }
}

kernel void SURF_computeDescriptors64(global uchar* imgTex, int img_step, int img_offset, int img_rows, int img_cols, global const float* keypoints, int keypoints_step, int keypoints_offset, global float* descriptors, int descriptors_step, int descriptors_offset) {
  descriptors_step /= sizeof(float);
  keypoints_step /= sizeof(float);
  global const float* featureX = keypoints + 0 * keypoints_step;
  global const float* featureY = keypoints + 1 * keypoints_step;
  global const float* featureSize = keypoints + 4 * keypoints_step;
  global const float* featureDir = keypoints + 5 * keypoints_step;

  volatile local float sdx[25];
  volatile local float sdy[25];
  volatile local float sdxabs[25];
  volatile local float sdyabs[25];
  volatile local float s_PATCH[6 * 6];

  calc_dx_dy(imgTex, img_step, img_offset, img_rows, img_cols, sdx, sdy, s_PATCH, featureX, featureY, featureSize, featureDir);
  barrier(0x01);

  const int tid = get_local_id(1) * get_local_size(0) + get_local_id(0);

  if (tid < 25) {
    sdxabs[hook(28, tid)] = fabs(sdx[hook(29, tid)]);
    sdyabs[hook(30, tid)] = fabs(sdy[hook(31, tid)]);
  }
  barrier(0x01);

  reduce_sum25(sdx, sdy, sdxabs, sdyabs, tid);

  barrier(0x01);
  if (tid == 0) {
    global float* descriptors_block = descriptors + descriptors_step * get_group_id(0) + (get_group_id(1) << 2);

    descriptors_block[hook(32, 0)] = sdx[hook(29, 0)];
    descriptors_block[hook(32, 1)] = sdy[hook(31, 0)];
    descriptors_block[hook(32, 2)] = sdxabs[hook(28, 0)];
    descriptors_block[hook(32, 3)] = sdyabs[hook(30, 0)];
  }
}