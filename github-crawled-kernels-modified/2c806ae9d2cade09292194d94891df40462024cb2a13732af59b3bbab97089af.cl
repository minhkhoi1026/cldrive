//{"dst_buf":3,"pairs":5,"radius":4,"src_buf":0,"src_height":2,"src_width":1,"xs":6,"ys":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float colordiff(float4 pixA, float4 pixB) {
  float4 pix = pixA - pixB;
  pix *= pix;
  return pix.x + pix.y + pix.z;
}

kernel void snn_mean(global const float4* src_buf, int src_width, int src_height, global float4* dst_buf, int radius, int pairs) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int offset = gidy * get_global_size(0) + gidx;

  global const float4* center_pix = src_buf + ((radius + gidx) + (gidy + radius) * src_width);
  float4 accumulated = 0;

  int count = 0;
  if (pairs == 2) {
    for (int i = -radius; i < 0; i++) {
      for (int j = -radius; j < 0; j++) {
        global const float4* selected_pix = center_pix;
        float best_diff = 1000.0f;

        int xs[4] = {gidx + j + radius, gidx - j + radius, gidx - j + radius, gidx + j + radius};
        int ys[4] = {gidy + i + radius, gidy - i + radius, gidy + i + radius, gidy - i + radius};

        for (int k = 0; k < 4; k++) {
          if (xs[hook(6, k)] >= 0 && xs[hook(6, k)] < src_width && ys[hook(7, k)] >= 0 && ys[hook(7, k)] < src_height) {
            global const float4* tpix = src_buf + (xs[hook(6, k)] + ys[hook(7, k)] * src_width);
            float diff = colordiff(*tpix, *center_pix);
            if (diff < best_diff) {
              best_diff = diff;
              selected_pix = tpix;
            }
          }
        }

        accumulated += *selected_pix;

        ++count;
        if (i == 0 && j == 0)
          break;
      }
    }
    dst_buf[hook(3, offset)] = accumulated / count;
    return;
  } else if (pairs == 1) {
    for (int i = -radius; i <= 0; i++) {
      for (int j = -radius; j <= radius; j++) {
        global const float4* selected_pix = center_pix;
        float best_diff = 1000.0f;

        if (i != 0 && j != 0) {
          int xs[4] = {gidx + i + radius, gidx - i + radius, gidx - i + radius, gidx + i + radius};
          int ys[4] = {gidy + j + radius, gidy - j + radius, gidy + j + radius, gidy - j + radius};

          for (i = 0; i < 2; i++) {
            if (xs[hook(6, i)] >= 0 && xs[hook(6, i)] < src_width && ys[hook(7, i)] >= 0 && ys[hook(7, i)] < src_height) {
              global const float4* tpix = src_buf + (xs[hook(6, i)] + ys[hook(7, i)] * src_width);
              float diff = colordiff(*tpix, *center_pix);
              if (diff < best_diff) {
                best_diff = diff;
                selected_pix = tpix;
              }
            }
          }
        }
        accumulated += *selected_pix;
        ++count;
        if (i == 0 && j == 0)
          break;
      }
    }
    dst_buf[hook(3, offset)] = accumulated / count;
    return;
  }
  return;
}