//{"IC":5,"IH":4,"IW":3,"OC":8,"OH":7,"OW":6,"in":0,"in8":20,"in8_0":10,"in8_1":12,"in8_2":13,"in8_3":14,"in8_4":15,"in8_5":16,"in8_6":17,"in8_7":18,"in_local":9,"out":1,"out_local":19,"w":2,"w8":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Convolution1x1_NHWC(const global float* in, const global float* out, const global float* w, int IW, int IH, int IC, int OW, int OH, int OC) {
  local float in_local[8 * 1024];
  local float out_local[8 * 1024];

  const int sizeAct = IW * IC;

  event_t e1 = async_work_group_copy(in_local, in + get_group_id(0) * sizeAct, sizeAct, 0);
  wait_group_events(1, &e1);

  int oh = get_global_id(0);
  int oc = get_global_id(1);

  int stride;
  int write_output = 0;
  global float* src;

  global float8* w8 = (global float8*)(&w[hook(2, oc * IC)]);
  global float* w1 = (global float*)(&w[hook(2, oc * IC)]);

  for (unsigned int ow = 0; ow < (OW & (~0x7)); ow += 8) {
    unsigned int iw = ow;
    unsigned int ih = oh;

    float8 val8_0 = 0.0f;
    float8 val8_1 = 0.0f;
    float8 val8_2 = 0.0f;
    float8 val8_3 = 0.0f;
    float8 val8_4 = 0.0f;
    float8 val8_5 = 0.0f;
    float8 val8_6 = 0.0f;
    float8 val8_7 = 0.0f;

    local float8* in8_0 = (local float8*)(&in_local[hook(9, (iw + 0) * IC)]);
    local float8* in8_1 = (local float8*)(&in_local[hook(9, (iw + 1) * IC)]);
    local float8* in8_2 = (local float8*)(&in_local[hook(9, (iw + 2) * IC)]);
    local float8* in8_3 = (local float8*)(&in_local[hook(9, (iw + 3) * IC)]);
    local float8* in8_4 = (local float8*)(&in_local[hook(9, (iw + 4) * IC)]);
    local float8* in8_5 = (local float8*)(&in_local[hook(9, (iw + 5) * IC)]);
    local float8* in8_6 = (local float8*)(&in_local[hook(9, (iw + 6) * IC)]);
    local float8* in8_7 = (local float8*)(&in_local[hook(9, (iw + 7) * IC)]);

    for (unsigned int ic = 0; ic < IC / 8; ++ic) {
      val8_0 += (in8_0[hook(10, ic)]) * (w8[hook(11, ic)]);
      val8_1 += (in8_1[hook(12, ic)]) * (w8[hook(11, ic)]);
      val8_2 += (in8_2[hook(13, ic)]) * (w8[hook(11, ic)]);
      val8_3 += (in8_3[hook(14, ic)]) * (w8[hook(11, ic)]);
      val8_4 += (in8_4[hook(15, ic)]) * (w8[hook(11, ic)]);
      val8_5 += (in8_5[hook(16, ic)]) * (w8[hook(11, ic)]);
      val8_6 += (in8_6[hook(17, ic)]) * (w8[hook(11, ic)]);
      val8_7 += (in8_7[hook(18, ic)]) * (w8[hook(11, ic)]);
    }

    float val_0 = 0.0f;
    float val_1 = 0.0f;
    float val_2 = 0.0f;
    float val_3 = 0.0f;
    float val_4 = 0.0f;
    float val_5 = 0.0f;
    float val_6 = 0.0f;
    float val_7 = 0.0f;
    for (unsigned int ic = IC & (~0x7); ic < IC; ++ic) {
      val_0 += *((local float*)in8_0 + ic) * (*((global float*)w8 + ic));
      val_1 += *((local float*)in8_1 + ic) * (*((global float*)w8 + ic));
      val_2 += *((local float*)in8_2 + ic) * (*((global float*)w8 + ic));
      val_3 += *((local float*)in8_3 + ic) * (*((global float*)w8 + ic));
      val_4 += *((local float*)in8_4 + ic) * (*((global float*)w8 + ic));
      val_5 += *((local float*)in8_5 + ic) * (*((global float*)w8 + ic));
      val_6 += *((local float*)in8_6 + ic) * (*((global float*)w8 + ic));
      val_7 += *((local float*)in8_7 + ic) * (*((global float*)w8 + ic));
    }
    out_local[hook(19, ow + 0)] = __builtin_shave_sau_sumx_f16_r(val8_0) + val_0;
    out_local[hook(19, ow + 1)] = __builtin_shave_sau_sumx_f16_r(val8_1) + val_1;
    out_local[hook(19, ow + 2)] = __builtin_shave_sau_sumx_f16_r(val8_2) + val_2;
    out_local[hook(19, ow + 3)] = __builtin_shave_sau_sumx_f16_r(val8_3) + val_3;
    out_local[hook(19, ow + 4)] = __builtin_shave_sau_sumx_f16_r(val8_4) + val_4;
    out_local[hook(19, ow + 5)] = __builtin_shave_sau_sumx_f16_r(val8_5) + val_5;
    out_local[hook(19, ow + 6)] = __builtin_shave_sau_sumx_f16_r(val8_6) + val_6;
    out_local[hook(19, ow + 7)] = __builtin_shave_sau_sumx_f16_r(val8_7) + val_7;
  }
  for (unsigned int ow = (OW & (~0x7)); ow < OW; ow++) {
    unsigned int iw = ow;
    unsigned int ih = oh;

    float8 val8 = 0.0f;

    local float8* in8 = (local float8*)(&in_local[hook(9, iw * IC)]);

    for (unsigned int ic = 0; ic < IC / 8; ++ic) {
      val8 += (in8[hook(20, ic)]) * (w8[hook(11, ic)]);
    }

    float val = 0.0f;
    for (unsigned int ic = (IC & (~0x7)); ic < IC; ++ic) {
      val += (*((local float*)in8 + ic)) * (*((global float*)w8 + ic));
    }
    out_local[hook(19, ow)] = __builtin_shave_sau_sumx_f16_r(val8) + val;
  }

  barrier(0x01);

  event_t e2 = async_work_group_copy(out + get_group_id(1) * OW * OH + get_group_id(0) * OW, out_local, OW, 0);
  wait_group_events(1, &e2);
}