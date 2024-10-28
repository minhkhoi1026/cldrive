//{"dt":0,"field":6,"in":1,"out":2,"v_x":3,"v_y":4,"vals":5}
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
    vals[hook(5, i)].w = elem_index(pos.x + i % 2, pos.y + i / 2, n_row, n_col);
    vals[hook(5, i)].xy = grid_pos(vals[hook(5, i)].w, n_col);
  }

  float2 x_range, y_range;
  if (pos.x < 0) {
    x_range.x = -1.f;
    x_range.y = 0.f;
  } else if (pos.x > n_col - 1) {
    x_range.x = n_col - 1;
    x_range.y = n_col;
  } else {
    x_range.x = vals[hook(5, 0)].x;
    x_range.y = vals[hook(5, 1)].x;
  }
  if (pos.y < 0) {
    y_range.x = -1.f;
    y_range.y = 0.f;
  } else if (pos.y > n_row - 1) {
    y_range.x = n_row - 1;
    y_range.y = n_row;
  } else {
    y_range.x = vals[hook(5, 0)].y;
    y_range.y = vals[hook(5, 2)].y;
  }
  pos.x = ((pos.x - x_range.x) / (x_range.y - x_range.x));
  pos.y = ((pos.y - y_range.x) / (y_range.y - y_range.x));
  return field[hook(6, vals[0hook(5, 0).w)] * (1 - pos.x) * (1 - pos.y) + field[hook(6, vals[1hook(5, 1).w)] * pos.x * (1 - pos.y) + field[hook(6, vals[2hook(5, 2).w)] * (1 - pos.x) * pos.y + field[hook(6, vals[3hook(5, 3).w)] * pos.x * pos.y;
}

kernel void advect_img_field(float dt, read_only image2d_t in, write_only image2d_t out, global float* v_x, global float* v_y) {
  int2 id = (int2)(get_global_id(0), get_global_id(1));
  int2 dim = (int2)(get_global_size(0), get_global_size(1));
  float2 pos = (float2)(id.x, id.y);
  float2 x_pos = (float2)(pos.x + 0.5f, pos.y);
  float2 y_pos = (float2)(pos.x, pos.y + 0.5f);

  float2 vel = (float2)(bilinear_interpolate(x_pos, v_x, dim.y, dim.x + 1), bilinear_interpolate(y_pos, v_y, dim.y + 1, dim.x));

  pos -= 0.5f * dt * vel;
  x_pos = (float2)(pos.x + 0.5f, pos.y);
  y_pos = (float2)(pos.x, pos.y + 0.5f);
  vel = (float2)(bilinear_interpolate(x_pos, v_x, dim.y, dim.x + 1), bilinear_interpolate(y_pos, v_y, dim.y + 1, dim.x));

  pos -= dt * vel;

  pos = (pos + (float2)(0.5f, 0.5f)) / convert_float2(get_image_dim(in));

  sampler_t linear = 1 | 6 | 0x20;
  float4 val = read_imagef(in, linear, pos);
  write_imagef(out, id, val);
}