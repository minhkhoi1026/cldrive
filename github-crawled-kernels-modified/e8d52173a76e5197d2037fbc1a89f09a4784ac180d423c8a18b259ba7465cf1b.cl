//{"field":4,"float3":0,"img":1,"img_read":2,"vals":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int elem_index(float x, float y, int n_row, int n_col) {
  if (x < 0) {
    x += n_col * (abs((int)x / n_col) + 1);
  }
  if (y < 0) {
    y += n_row * (abs((int)y / n_row) + 1);
  }
  return (int)x % n_col + ((int)y % n_row) * n_col;
}

int2 grid_pos(int i, int row_len) {
  return (int2)(i % row_len, (i - i % row_len) / row_len);
}

float wrap(float a, int dim) {
  if (a < 0) {
    int offset = dim * (abs((int)a) / dim + 1);
    return a + offset;
  } else if (a > dim) {
    int offset = dim * ((int)a / dim);
    return a - offset;
  }
  return a;
}

float bilinear_interpolate(float2 pos, global float* field, int n_row, int n_col) {
  if (pos.x < -1 || pos.x > n_col) {
    pos.x = wrap(pos.x, n_col);
  }
  if (pos.y < -1 || pos.y > n_row) {
    pos.y = wrap(pos.y, n_row);
  }

  int4 vals[4];
  for (int i = 0; i < 4; ++i) {
    vals[hook(3, i)].w = elem_index(pos.x + i % 2, pos.y + i / 2, n_row, n_col);
    vals[hook(3, i)].xy = grid_pos(vals[hook(3, i)].w, n_col);
  }

  float2 x_range, y_range;
  if (pos.x < 0) {
    x_range.x = -1.f;
    x_range.y = 0.f;
  } else if (pos.x > n_col - 1) {
    x_range.x = n_col - 1;
    x_range.y = n_col;
  } else {
    x_range.x = vals[hook(3, 0)].x;
    x_range.y = vals[hook(3, 1)].x;
  }
  if (pos.y < 0) {
    y_range.x = -1.f;
    y_range.y = 0.f;
  } else if (pos.y > n_row - 1) {
    y_range.x = n_row - 1;
    y_range.y = n_row;
  } else {
    y_range.x = vals[hook(3, 0)].y;
    y_range.y = vals[hook(3, 2)].y;
  }
  pos.x = ((pos.x - x_range.x) / (x_range.y - x_range.x));
  pos.y = ((pos.y - y_range.x) / (y_range.y - y_range.x));
  return field[hook(4, vals[0hook(3, 0).w)] * (1 - pos.x) * (1 - pos.y) + field[hook(4, vals[1hook(3, 1).w)] * pos.x * (1 - pos.y) + field[hook(4, vals[2hook(3, 2).w)] * (1 - pos.x) * pos.y + field[hook(4, vals[3hook(3, 3).w)] * pos.x * pos.y;
}

kernel void set_pixel(global float* float3, write_only image2d_t img, read_only image2d_t img_read) {
  int2 img_dim = get_image_dim(img);
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  sampler_t sampler = 0 | 6 | 0x10;
  float4 px_color = read_imagef(img_read, sampler, coord);
  px_color = px_color * 0.f + (float4)(float3[hook(0, 0)], float3[hook(0, 1)], float3[hook(0, 2)], float3[hook(0, 3)]);
  write_imagef(img, coord, px_color);
}