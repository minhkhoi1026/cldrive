//{"has_alpha":5,"horizontal":2,"in":0,"keep_signal":4,"out":1,"vertical":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_edgesobel(global float4* in, global float4* out, const int horizontal, const int vertical, const int keep_signal, const int has_alpha) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  float4 hor_grad = 0.0f;
  float4 ver_grad = 0.0f;
  float4 gradient = 0.0f;

  int dst_width = get_global_size(0);
  int src_width = dst_width + 1 * 2;

  int i = gidx + 1, j = gidy + 1;
  int gid1d = i + j * src_width;

  float4 pix_fl = in[hook(0, gid1d - 1 - src_width)];
  float4 pix_fm = in[hook(0, gid1d - src_width)];
  float4 pix_fr = in[hook(0, gid1d + 1 - src_width)];
  float4 pix_ml = in[hook(0, gid1d - 1)];
  float4 pix_mm = in[hook(0, gid1d)];
  float4 pix_mr = in[hook(0, gid1d + 1)];
  float4 pix_bl = in[hook(0, gid1d - 1 + src_width)];
  float4 pix_bm = in[hook(0, gid1d + src_width)];
  float4 pix_br = in[hook(0, gid1d + 1 + src_width)];

  if (horizontal) {
    hor_grad += -1.0f * pix_fl + 1.0f * pix_fr - 2.0f * pix_ml + 2.0f * pix_mr - 1.0f * pix_bl + 1.0f * pix_br;
  }
  if (vertical) {
    ver_grad += -1.0f * pix_fl - 2.0f * pix_fm - 1.0f * pix_fr + 1.0f * pix_bl + 2.0f * pix_bm + 1.0f * pix_br;
  }

  if (horizontal && vertical) {
    gradient = sqrt(hor_grad * hor_grad + ver_grad * ver_grad) / 1.41f;
  } else {
    if (keep_signal)
      gradient = hor_grad + ver_grad;
    else
      gradient = fabs(hor_grad + ver_grad);
  }

  if (has_alpha) {
    gradient.w = pix_mm.w;
  } else {
    gradient.w = 1.0f;
  }

  out[hook(1, gidx + gidy * dst_width)] = gradient;
}