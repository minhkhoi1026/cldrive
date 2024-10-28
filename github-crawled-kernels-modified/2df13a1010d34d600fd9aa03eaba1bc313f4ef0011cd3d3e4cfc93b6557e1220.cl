//{"dst_buf":2,"dst_stride":3,"metric_reference":5,"offsets":4,"src_buf":0,"src_stride":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void noise_reduction_cl(global float4* src_buf, int src_stride, global float4* dst_buf, int dst_stride) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  global float4* center_pix = src_buf + (gidy + 1) * src_stride + gidx + 1;
  int dst_offset = dst_stride * gidy + gidx;

  int offsets[8] = {(((-1) + ((-1) * (src_stride)))), (((0) + ((-1) * (src_stride)))), (((1) + ((-1) * (src_stride)))), (((-1) + ((0) * (src_stride)))), (((1) + ((0) * (src_stride)))), (((-1) + ((1) * (src_stride)))), (((0) + ((1) * (src_stride)))), (((1) + ((1) * (src_stride))))};

  float4 sum;
  int4 count;
  float4 cur;
  float4 metric_reference[(8 / 2)];

  for (int axis = 0; axis < (8 / 2); axis++) {
    float4 before_pix = *(center_pix + offsets[hook(4, axis)]);
    float4 after_pix = *(center_pix + offsets[hook(4, (8 - (axis) - 1))]);
    metric_reference[hook(5, axis)] = (((*center_pix) * (float4)(2.0f) - (before_pix) - (after_pix)) * ((*center_pix) * (float4)(2.0f) - (before_pix) - (after_pix)));
  }

  cur = sum = *center_pix;
  count = 1;

  for (int direction = 0; direction < 8; direction++) {
    float4 pix = *(center_pix + offsets[hook(4, direction)]);
    float4 value = (pix + cur) * (0.5f);
    int axis;
    int4 mask = {1, 1, 1, 0};

    for (axis = 0; axis < (8 / 2); axis++) {
      float4 before_pix = *(center_pix + offsets[hook(4, axis)]);
      float4 after_pix = *(center_pix + offsets[hook(4, (8 - (axis) - 1))]);

      float4 metric_new = (((value) * (float4)(2.0f) - (before_pix) - (after_pix)) * ((value) * (float4)(2.0f) - (before_pix) - (after_pix)));

      mask = ((metric_new) < (metric_reference[hook(5, axis)])) & mask;
    }
    sum += mask > 0 ? value : (float4)(0.0);
    count += mask > 0 ? 1 : 0;
  }
  dst_buf[hook(2, dst_offset)] = (sum / convert_float4(count));
  dst_buf[hook(2, dst_offset)].w = cur.w;
}