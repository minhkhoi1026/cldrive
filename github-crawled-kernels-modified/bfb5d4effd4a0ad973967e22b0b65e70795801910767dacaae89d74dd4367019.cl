//{"a":43,"alpha":6,"data":27,"data_in":0,"data_out":3,"f41_c":16,"f41_r":13,"f42_c":15,"f42_r":14,"g_gamma":1,"g_iterations":4,"g_status":5,"gamma":28,"gradient":30,"otf_mask":2,"otf_mask_sqr":31,"s":40,"t1_c":19,"t1_r":17,"t_c":12,"t_r":11,"u":29,"u_c":36,"u_fft_c":34,"u_fft_r":32,"u_p":39,"u_r":35,"v1":23,"v2":24,"v3":26,"w1":25,"w1_f":37,"w1_i":38,"w2":33,"x1_c":22,"x1_r":21,"x_c":10,"x_r":9,"y":41,"y1_c":20,"y1_r":18,"y_c":8,"y_r":7,"ys":42}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void fft4(float4 x_r, float4 x_c, float4* y_r, float4* y_c) {
  float t1_r = x_r.x + x_r.z;
  float t1_c = x_c.x + x_c.z;

  float t2_r = x_r.x - x_r.z;
  float t2_c = x_c.x - x_c.z;

  float t3_r = x_r.y + x_r.w;
  float t3_c = x_c.y + x_c.w;

  float t4_r = x_r.y - x_r.w;
  float t4_c = x_c.y - x_c.w;

  y_r[hook(7, 0)].x = t1_r + t3_r;
  y_r[hook(7, 0)].y = t2_r + t4_c;
  y_r[hook(7, 0)].z = t1_r - t3_r;
  y_r[hook(7, 0)].w = t2_r - t4_c;

  y_c[hook(8, 0)].x = t1_c + t3_c;
  y_c[hook(8, 0)].y = t2_c - t4_r;
  y_c[hook(8, 0)].z = t1_c - t3_c;
  y_c[hook(8, 0)].w = t2_c + t4_r;
}

void ifft4(float4 x_r, float4 x_c, float4* y_r, float4* y_c) {
  float t1_r = x_r.x + x_r.z;
  float t1_c = x_c.x + x_c.z;

  float t2_r = x_r.x - x_r.z;
  float t2_c = x_c.x - x_c.z;

  float t3_r = x_r.y + x_r.w;
  float t3_c = x_c.y + x_c.w;

  float t4_r = x_r.y - x_r.w;
  float t4_c = x_c.y - x_c.w;

  y_r[hook(7, 0)].x = t1_r + t3_r;
  y_r[hook(7, 0)].y = t2_r - t4_c;
  y_r[hook(7, 0)].z = t1_r - t3_r;
  y_r[hook(7, 0)].w = t2_r + t4_c;

  y_c[hook(8, 0)].x = t1_c + t3_c;
  y_c[hook(8, 0)].y = t2_c + t4_r;
  y_c[hook(8, 0)].z = t1_c - t3_c;
  y_c[hook(8, 0)].w = t2_c - t4_r;

  y_r[hook(7, 0)] = y_r[hook(7, 0)] * 0.25f;
  y_c[hook(8, 0)] = y_c[hook(8, 0)] * 0.25f;
}

void fft8(float4* x_r, float4* x_c, float4* y_r, float4* y_c) {
  float4 t_r;
  float4 t_c;
  float4 f41_r;
  float4 f41_c;
  float4 f42_r;
  float4 f42_c;

  t_r = (float4)(x_r[hook(9, 0)].x, x_r[hook(9, 0)].z, x_r[hook(9, 1)].x, x_r[hook(9, 1)].z);
  t_c = (float4)(x_c[hook(10, 0)].x, x_c[hook(10, 0)].z, x_c[hook(10, 1)].x, x_c[hook(10, 1)].z);
  fft4(t_r, t_c, &f41_r, &f41_c);

  t_r = (float4)(x_r[hook(9, 0)].y, x_r[hook(9, 0)].w, x_r[hook(9, 1)].y, x_r[hook(9, 1)].w);
  t_c = (float4)(x_c[hook(10, 0)].y, x_c[hook(10, 0)].w, x_c[hook(10, 1)].y, x_c[hook(10, 1)].w);
  fft4(t_r, t_c, &f42_r, &f42_c);

  float4 r1 = (float4)(1.0f, 7.07106781e-01f, 0.0f, -7.07106781e-01f);
  float4 c1 = (float4)(0.0f, 7.07106781e-01f, 1.0f, 7.07106781e-01f);
  y_r[hook(7, 0)] = f41_r + f42_r * r1 + f42_c * c1;
  y_c[hook(8, 0)] = f41_c + f42_c * r1 - f42_r * c1;
  y_r[hook(7, 1)] = f41_r - f42_r * r1 - f42_c * c1;
  y_c[hook(8, 1)] = f41_c - f42_c * r1 + f42_r * c1;
}

void ifft8(float4* x_r, float4* x_c, float4* y_r, float4* y_c) {
  float4 t_r;
  float4 t_c;
  float4 f41_r;
  float4 f41_c;
  float4 f42_r;
  float4 f42_c;

  t_r = (float4)(x_r[hook(9, 0)].x, x_r[hook(9, 0)].z, x_r[hook(9, 1)].x, x_r[hook(9, 1)].z);
  t_c = (float4)(x_c[hook(10, 0)].x, x_c[hook(10, 0)].z, x_c[hook(10, 1)].x, x_c[hook(10, 1)].z);
  ifft4(t_r, t_c, &f41_r, &f41_c);

  t_r = (float4)(x_r[hook(9, 0)].y, x_r[hook(9, 0)].w, x_r[hook(9, 1)].y, x_r[hook(9, 1)].w);
  t_c = (float4)(x_c[hook(10, 0)].y, x_c[hook(10, 0)].w, x_c[hook(10, 1)].y, x_c[hook(10, 1)].w);
  ifft4(t_r, t_c, &f42_r, &f42_c);

  float4 r1 = (float4)(1.0f, 7.07106781e-01f, 0.0f, -7.07106781e-01f);
  float4 c1 = (float4)(0.0f, -7.07106781e-01f, -1.0f, -7.07106781e-01f);
  y_r[hook(7, 0)] = f41_r + f42_r * r1 + f42_c * c1;
  y_c[hook(8, 0)] = f41_c + f42_c * r1 - f42_r * c1;
  y_r[hook(7, 1)] = f41_r - f42_r * r1 - f42_c * c1;
  y_c[hook(8, 1)] = f41_c - f42_c * r1 + f42_r * c1;

  y_r[hook(7, 0)] = y_r[hook(7, 0)] * 0.5f;
  y_c[hook(8, 0)] = y_c[hook(8, 0)] * 0.5f;
  y_r[hook(7, 1)] = y_r[hook(7, 1)] * 0.5f;
  y_c[hook(8, 1)] = y_c[hook(8, 1)] * 0.5f;
}

void fft16(float4* x_r, float4* x_c, float4* y_r, float4* y_c) {
  float4 t_r[2];
  float4 t_c[2];
  float4 f41_r[2];
  float4 f41_c[2];
  float4 f42_r[2];
  float4 f42_c[2];

  t_r[hook(11, 0)] = (float4)(x_r[hook(9, 0)].x, x_r[hook(9, 0)].z, x_r[hook(9, 1)].x, x_r[hook(9, 1)].z);
  t_c[hook(12, 0)] = (float4)(x_c[hook(10, 0)].x, x_c[hook(10, 0)].z, x_c[hook(10, 1)].x, x_c[hook(10, 1)].z);
  t_r[hook(11, 1)] = (float4)(x_r[hook(9, 2)].x, x_r[hook(9, 2)].z, x_r[hook(9, 3)].x, x_r[hook(9, 3)].z);
  t_c[hook(12, 1)] = (float4)(x_c[hook(10, 2)].x, x_c[hook(10, 2)].z, x_c[hook(10, 3)].x, x_c[hook(10, 3)].z);
  fft8(t_r, t_c, f41_r, f41_c);

  t_r[hook(11, 0)] = (float4)(x_r[hook(9, 0)].y, x_r[hook(9, 0)].w, x_r[hook(9, 1)].y, x_r[hook(9, 1)].w);
  t_c[hook(12, 0)] = (float4)(x_c[hook(10, 0)].y, x_c[hook(10, 0)].w, x_c[hook(10, 1)].y, x_c[hook(10, 1)].w);
  t_r[hook(11, 1)] = (float4)(x_r[hook(9, 2)].y, x_r[hook(9, 2)].w, x_r[hook(9, 3)].y, x_r[hook(9, 3)].w);
  t_c[hook(12, 1)] = (float4)(x_c[hook(10, 2)].y, x_c[hook(10, 2)].w, x_c[hook(10, 3)].y, x_c[hook(10, 3)].w);
  fft8(t_r, t_c, f42_r, f42_c);

  float4 r1 = (float4)(1.0f, 9.23879533e-01f, 7.07106781e-01f, 3.82683432e-01f);
  float4 c1 = (float4)(0.0f, 3.82683432e-01f, 7.07106781e-01f, 9.23879533e-01f);
  y_r[hook(7, 0)] = f41_r[hook(13, 0)] + f42_r[hook(14, 0)] * r1 + f42_c[hook(15, 0)] * c1;
  y_c[hook(8, 0)] = f41_c[hook(16, 0)] + f42_c[hook(15, 0)] * r1 - f42_r[hook(14, 0)] * c1;
  y_r[hook(7, 2)] = f41_r[hook(13, 0)] - f42_r[hook(14, 0)] * r1 - f42_c[hook(15, 0)] * c1;
  y_c[hook(8, 2)] = f41_c[hook(16, 0)] - f42_c[hook(15, 0)] * r1 + f42_r[hook(14, 0)] * c1;

  r1 = (float4)(0.0f, -3.82683432e-01f, -7.07106781e-01f, -9.23879533e-01f);
  c1 = (float4)(1.0f, 9.23879533e-01f, 7.07106781e-01f, 3.82683432e-01f);
  y_r[hook(7, 1)] = f41_r[hook(13, 1)] + f42_r[hook(14, 1)] * r1 + f42_c[hook(15, 1)] * c1;
  y_c[hook(8, 1)] = f41_c[hook(16, 1)] + f42_c[hook(15, 1)] * r1 - f42_r[hook(14, 1)] * c1;
  y_r[hook(7, 3)] = f41_r[hook(13, 1)] - f42_r[hook(14, 1)] * r1 - f42_c[hook(15, 1)] * c1;
  y_c[hook(8, 3)] = f41_c[hook(16, 1)] - f42_c[hook(15, 1)] * r1 + f42_r[hook(14, 1)] * c1;
}

void fft16_lvar(local float4* x_r, local float4* x_c, local float4* y_r, local float4* y_c) {
  float4 t_r[2];
  float4 t_c[2];
  float4 f41_r[2];
  float4 f41_c[2];
  float4 f42_r[2];
  float4 f42_c[2];

  t_r[hook(11, 0)] = (float4)(x_r[hook(9, 0)].x, x_r[hook(9, 0)].z, x_r[hook(9, 1)].x, x_r[hook(9, 1)].z);
  t_c[hook(12, 0)] = (float4)(x_c[hook(10, 0)].x, x_c[hook(10, 0)].z, x_c[hook(10, 1)].x, x_c[hook(10, 1)].z);
  t_r[hook(11, 1)] = (float4)(x_r[hook(9, 2)].x, x_r[hook(9, 2)].z, x_r[hook(9, 3)].x, x_r[hook(9, 3)].z);
  t_c[hook(12, 1)] = (float4)(x_c[hook(10, 2)].x, x_c[hook(10, 2)].z, x_c[hook(10, 3)].x, x_c[hook(10, 3)].z);
  fft8(t_r, t_c, f41_r, f41_c);

  t_r[hook(11, 0)] = (float4)(x_r[hook(9, 0)].y, x_r[hook(9, 0)].w, x_r[hook(9, 1)].y, x_r[hook(9, 1)].w);
  t_c[hook(12, 0)] = (float4)(x_c[hook(10, 0)].y, x_c[hook(10, 0)].w, x_c[hook(10, 1)].y, x_c[hook(10, 1)].w);
  t_r[hook(11, 1)] = (float4)(x_r[hook(9, 2)].y, x_r[hook(9, 2)].w, x_r[hook(9, 3)].y, x_r[hook(9, 3)].w);
  t_c[hook(12, 1)] = (float4)(x_c[hook(10, 2)].y, x_c[hook(10, 2)].w, x_c[hook(10, 3)].y, x_c[hook(10, 3)].w);
  fft8(t_r, t_c, f42_r, f42_c);

  float4 r1 = (float4)(1.0f, 9.23879533e-01f, 7.07106781e-01f, 3.82683432e-01f);
  float4 c1 = (float4)(0.0f, 3.82683432e-01f, 7.07106781e-01f, 9.23879533e-01f);
  y_r[hook(7, 0)] = f41_r[hook(13, 0)] + f42_r[hook(14, 0)] * r1 + f42_c[hook(15, 0)] * c1;
  y_c[hook(8, 0)] = f41_c[hook(16, 0)] + f42_c[hook(15, 0)] * r1 - f42_r[hook(14, 0)] * c1;
  y_r[hook(7, 2)] = f41_r[hook(13, 0)] - f42_r[hook(14, 0)] * r1 - f42_c[hook(15, 0)] * c1;
  y_c[hook(8, 2)] = f41_c[hook(16, 0)] - f42_c[hook(15, 0)] * r1 + f42_r[hook(14, 0)] * c1;

  r1 = (float4)(0.0f, -3.82683432e-01f, -7.07106781e-01f, -9.23879533e-01f);
  c1 = (float4)(1.0f, 9.23879533e-01f, 7.07106781e-01f, 3.82683432e-01f);
  y_r[hook(7, 1)] = f41_r[hook(13, 1)] + f42_r[hook(14, 1)] * r1 + f42_c[hook(15, 1)] * c1;
  y_c[hook(8, 1)] = f41_c[hook(16, 1)] + f42_c[hook(15, 1)] * r1 - f42_r[hook(14, 1)] * c1;
  y_r[hook(7, 3)] = f41_r[hook(13, 1)] - f42_r[hook(14, 1)] * r1 - f42_c[hook(15, 1)] * c1;
  y_c[hook(8, 3)] = f41_c[hook(16, 1)] - f42_c[hook(15, 1)] * r1 + f42_r[hook(14, 1)] * c1;
}

void ifft16(float4* x_r, float4* x_c, float4* y_r, float4* y_c) {
  float4 t_r[2];
  float4 t_c[2];
  float4 f41_r[2];
  float4 f41_c[2];
  float4 f42_r[2];
  float4 f42_c[2];

  t_r[hook(11, 0)] = (float4)(x_r[hook(9, 0)].x, x_r[hook(9, 0)].z, x_r[hook(9, 1)].x, x_r[hook(9, 1)].z);
  t_c[hook(12, 0)] = (float4)(x_c[hook(10, 0)].x, x_c[hook(10, 0)].z, x_c[hook(10, 1)].x, x_c[hook(10, 1)].z);
  t_r[hook(11, 1)] = (float4)(x_r[hook(9, 2)].x, x_r[hook(9, 2)].z, x_r[hook(9, 3)].x, x_r[hook(9, 3)].z);
  t_c[hook(12, 1)] = (float4)(x_c[hook(10, 2)].x, x_c[hook(10, 2)].z, x_c[hook(10, 3)].x, x_c[hook(10, 3)].z);
  ifft8(t_r, t_c, f41_r, f41_c);

  t_r[hook(11, 0)] = (float4)(x_r[hook(9, 0)].y, x_r[hook(9, 0)].w, x_r[hook(9, 1)].y, x_r[hook(9, 1)].w);
  t_c[hook(12, 0)] = (float4)(x_c[hook(10, 0)].y, x_c[hook(10, 0)].w, x_c[hook(10, 1)].y, x_c[hook(10, 1)].w);
  t_r[hook(11, 1)] = (float4)(x_r[hook(9, 2)].y, x_r[hook(9, 2)].w, x_r[hook(9, 3)].y, x_r[hook(9, 3)].w);
  t_c[hook(12, 1)] = (float4)(x_c[hook(10, 2)].y, x_c[hook(10, 2)].w, x_c[hook(10, 3)].y, x_c[hook(10, 3)].w);
  ifft8(t_r, t_c, f42_r, f42_c);

  float4 r1 = (float4)(1.0f, 9.23879533e-01f, 7.07106781e-01f, 3.82683432e-01f);
  float4 c1 = (float4)(0.0f, -3.82683432e-01f, -7.07106781e-01f, -9.23879533e-01f);
  y_r[hook(7, 0)] = f41_r[hook(13, 0)] + f42_r[hook(14, 0)] * r1 + f42_c[hook(15, 0)] * c1;
  y_c[hook(8, 0)] = f41_c[hook(16, 0)] + f42_c[hook(15, 0)] * r1 - f42_r[hook(14, 0)] * c1;
  y_r[hook(7, 2)] = f41_r[hook(13, 0)] - f42_r[hook(14, 0)] * r1 - f42_c[hook(15, 0)] * c1;
  y_c[hook(8, 2)] = f41_c[hook(16, 0)] - f42_c[hook(15, 0)] * r1 + f42_r[hook(14, 0)] * c1;

  r1 = (float4)(0.0f, -3.82683432e-01f, -7.07106781e-01f, -9.23879533e-01f);
  c1 = (float4)(-1.0f, -9.23879533e-01f, -7.07106781e-01f, -3.82683432e-01f);
  y_r[hook(7, 1)] = f41_r[hook(13, 1)] + f42_r[hook(14, 1)] * r1 + f42_c[hook(15, 1)] * c1;
  y_c[hook(8, 1)] = f41_c[hook(16, 1)] + f42_c[hook(15, 1)] * r1 - f42_r[hook(14, 1)] * c1;
  y_r[hook(7, 3)] = f41_r[hook(13, 1)] - f42_r[hook(14, 1)] * r1 - f42_c[hook(15, 1)] * c1;
  y_c[hook(8, 3)] = f41_c[hook(16, 1)] - f42_c[hook(15, 1)] * r1 + f42_r[hook(14, 1)] * c1;

  for (int i = 0; i < 4; i++) {
    y_r[hook(7, i)] = y_r[hook(7, i)] * 0.5f;
    y_c[hook(8, i)] = y_c[hook(8, i)] * 0.5f;
  }
}

void ifft16_lvar(local float4* x_r, local float4* x_c, local float4* y_r, local float4* y_c) {
  float4 t_r[2];
  float4 t_c[2];
  float4 f41_r[2];
  float4 f41_c[2];
  float4 f42_r[2];
  float4 f42_c[2];

  t_r[hook(11, 0)] = (float4)(x_r[hook(9, 0)].x, x_r[hook(9, 0)].z, x_r[hook(9, 1)].x, x_r[hook(9, 1)].z);
  t_c[hook(12, 0)] = (float4)(x_c[hook(10, 0)].x, x_c[hook(10, 0)].z, x_c[hook(10, 1)].x, x_c[hook(10, 1)].z);
  t_r[hook(11, 1)] = (float4)(x_r[hook(9, 2)].x, x_r[hook(9, 2)].z, x_r[hook(9, 3)].x, x_r[hook(9, 3)].z);
  t_c[hook(12, 1)] = (float4)(x_c[hook(10, 2)].x, x_c[hook(10, 2)].z, x_c[hook(10, 3)].x, x_c[hook(10, 3)].z);
  ifft8(t_r, t_c, f41_r, f41_c);

  t_r[hook(11, 0)] = (float4)(x_r[hook(9, 0)].y, x_r[hook(9, 0)].w, x_r[hook(9, 1)].y, x_r[hook(9, 1)].w);
  t_c[hook(12, 0)] = (float4)(x_c[hook(10, 0)].y, x_c[hook(10, 0)].w, x_c[hook(10, 1)].y, x_c[hook(10, 1)].w);
  t_r[hook(11, 1)] = (float4)(x_r[hook(9, 2)].y, x_r[hook(9, 2)].w, x_r[hook(9, 3)].y, x_r[hook(9, 3)].w);
  t_c[hook(12, 1)] = (float4)(x_c[hook(10, 2)].y, x_c[hook(10, 2)].w, x_c[hook(10, 3)].y, x_c[hook(10, 3)].w);
  ifft8(t_r, t_c, f42_r, f42_c);

  float4 r1 = (float4)(1.0f, 9.23879533e-01f, 7.07106781e-01f, 3.82683432e-01f);
  float4 c1 = (float4)(0.0f, -3.82683432e-01f, -7.07106781e-01f, -9.23879533e-01f);
  y_r[hook(7, 0)] = f41_r[hook(13, 0)] + f42_r[hook(14, 0)] * r1 + f42_c[hook(15, 0)] * c1;
  y_c[hook(8, 0)] = f41_c[hook(16, 0)] + f42_c[hook(15, 0)] * r1 - f42_r[hook(14, 0)] * c1;
  y_r[hook(7, 2)] = f41_r[hook(13, 0)] - f42_r[hook(14, 0)] * r1 - f42_c[hook(15, 0)] * c1;
  y_c[hook(8, 2)] = f41_c[hook(16, 0)] - f42_c[hook(15, 0)] * r1 + f42_r[hook(14, 0)] * c1;

  r1 = (float4)(0.0f, -3.82683432e-01f, -7.07106781e-01f, -9.23879533e-01f);
  c1 = (float4)(-1.0f, -9.23879533e-01f, -7.07106781e-01f, -3.82683432e-01f);
  y_r[hook(7, 1)] = f41_r[hook(13, 1)] + f42_r[hook(14, 1)] * r1 + f42_c[hook(15, 1)] * c1;
  y_c[hook(8, 1)] = f41_c[hook(16, 1)] + f42_c[hook(15, 1)] * r1 - f42_r[hook(14, 1)] * c1;
  y_r[hook(7, 3)] = f41_r[hook(13, 1)] - f42_r[hook(14, 1)] * r1 - f42_c[hook(15, 1)] * c1;
  y_c[hook(8, 3)] = f41_c[hook(16, 1)] - f42_c[hook(15, 1)] * r1 + f42_r[hook(14, 1)] * c1;

  for (int i = 0; i < 4; i++) {
    y_r[hook(7, i)] = y_r[hook(7, i)] * 0.5f;
    y_c[hook(8, i)] = y_c[hook(8, i)] * 0.5f;
  }
}

void fft_16x16_wg16(local float4* x_r, local float4* x_c, local float4* y_r, local float4* y_c, int lid) {
  int j;

  float4 t1_r[4];
  float4 t1_c[4];

  local float* y1_r = (local float*)y_r;
  local float* y1_c = (local float*)y_c;

  fft16_lvar(&(x_r[hook(9, lid * 4)]), &(x_c[hook(10, lid * 4)]), &(y_r[hook(7, lid * 4)]), &(y_c[hook(8, lid * 4)]));

  barrier(0x01);

  for (j = 0; j < 4; j++) {
    t1_r[hook(17, j)].x = y1_r[hook(18, (4 * j + 0) * 16 + lid)];
    t1_r[hook(17, j)].y = y1_r[hook(18, (4 * j + 1) * 16 + lid)];
    t1_r[hook(17, j)].z = y1_r[hook(18, (4 * j + 2) * 16 + lid)];
    t1_r[hook(17, j)].w = y1_r[hook(18, (4 * j + 3) * 16 + lid)];
    t1_c[hook(19, j)].x = y1_c[hook(20, (4 * j + 0) * 16 + lid)];
    t1_c[hook(19, j)].y = y1_c[hook(20, (4 * j + 1) * 16 + lid)];
    t1_c[hook(19, j)].z = y1_c[hook(20, (4 * j + 2) * 16 + lid)];
    t1_c[hook(19, j)].w = y1_c[hook(20, (4 * j + 3) * 16 + lid)];
  }

  fft16(t1_r, t1_c, t1_r, t1_c);

  for (j = 0; j < 4; j++) {
    y1_r[hook(18, (4 * j + 0) * 16 + lid)] = t1_r[hook(17, j)].x;
    y1_r[hook(18, (4 * j + 1) * 16 + lid)] = t1_r[hook(17, j)].y;
    y1_r[hook(18, (4 * j + 2) * 16 + lid)] = t1_r[hook(17, j)].z;
    y1_r[hook(18, (4 * j + 3) * 16 + lid)] = t1_r[hook(17, j)].w;
    y1_c[hook(20, (4 * j + 0) * 16 + lid)] = t1_c[hook(19, j)].x;
    y1_c[hook(20, (4 * j + 1) * 16 + lid)] = t1_c[hook(19, j)].y;
    y1_c[hook(20, (4 * j + 2) * 16 + lid)] = t1_c[hook(19, j)].z;
    y1_c[hook(20, (4 * j + 3) * 16 + lid)] = t1_c[hook(19, j)].w;
  }

  barrier(0x01);
}

void ifft_16x16_wg16(local float4* x_r, local float4* x_c, local float4* y_r, local float4* y_c, int lid) {
  int j;

  float4 t1_r[4];
  float4 t1_c[4];

  local float* x1_r = (local float*)x_r;
  local float* x1_c = (local float*)x_c;
  local float* y1_r = (local float*)y_r;
  local float* y1_c = (local float*)y_c;

  for (j = 0; j < 4; j++) {
    t1_r[hook(17, j)].x = x1_r[hook(21, (4 * j + 0) * 16 + lid)];
    t1_r[hook(17, j)].y = x1_r[hook(21, (4 * j + 1) * 16 + lid)];
    t1_r[hook(17, j)].z = x1_r[hook(21, (4 * j + 2) * 16 + lid)];
    t1_r[hook(17, j)].w = x1_r[hook(21, (4 * j + 3) * 16 + lid)];
    t1_c[hook(19, j)].x = x1_c[hook(22, (4 * j + 0) * 16 + lid)];
    t1_c[hook(19, j)].y = x1_c[hook(22, (4 * j + 1) * 16 + lid)];
    t1_c[hook(19, j)].z = x1_c[hook(22, (4 * j + 2) * 16 + lid)];
    t1_c[hook(19, j)].w = x1_c[hook(22, (4 * j + 3) * 16 + lid)];
  }

  ifft16(t1_r, t1_c, t1_r, t1_c);

  for (j = 0; j < 4; j++) {
    y1_r[hook(18, (4 * j + 0) * 16 + lid)] = t1_r[hook(17, j)].x;
    y1_r[hook(18, (4 * j + 1) * 16 + lid)] = t1_r[hook(17, j)].y;
    y1_r[hook(18, (4 * j + 2) * 16 + lid)] = t1_r[hook(17, j)].z;
    y1_r[hook(18, (4 * j + 3) * 16 + lid)] = t1_r[hook(17, j)].w;
    y1_c[hook(20, (4 * j + 0) * 16 + lid)] = t1_c[hook(19, j)].x;
    y1_c[hook(20, (4 * j + 1) * 16 + lid)] = t1_c[hook(19, j)].y;
    y1_c[hook(20, (4 * j + 2) * 16 + lid)] = t1_c[hook(19, j)].z;
    y1_c[hook(20, (4 * j + 3) * 16 + lid)] = t1_c[hook(19, j)].w;
  }

  barrier(0x01);

  ifft16_lvar(&(y_r[hook(7, lid * 4)]), &(y_c[hook(8, lid * 4)]), &(y_r[hook(7, lid * 4)]), &(y_c[hook(8, lid * 4)]));

  barrier(0x01);
}
void veccopy(local float4* v1, local float4* v2, int lid) {
  int i = lid * 4;

  v1[hook(23, i)] = v2[hook(24, i)];
  v1[hook(23, i + 1)] = v2[hook(24, i + 1)];
  v1[hook(23, i + 2)] = v2[hook(24, i + 2)];
  v1[hook(23, i + 3)] = v2[hook(24, i + 3)];
}

void vecncopy(local float4* v1, local float4* v2, int lid) {
  int i = lid * 4;

  v1[hook(23, i)] = -v2[hook(24, i)];
  v1[hook(23, i + 1)] = -v2[hook(24, i + 1)];
  v1[hook(23, i + 2)] = -v2[hook(24, i + 2)];
  v1[hook(23, i + 3)] = -v2[hook(24, i + 3)];
}

void vecdot(local float* w1, local float4* v1, local float4* v2, int lid) {
  int i = lid * 4;
  float sum = 0.0f;

  sum += dot(v1[hook(23, i)], v2[hook(24, i)]);
  sum += dot(v1[hook(23, i + 1)], v2[hook(24, i + 1)]);
  sum += dot(v1[hook(23, i + 2)], v2[hook(24, i + 2)]);
  sum += dot(v1[hook(23, i + 3)], v2[hook(24, i + 3)]);
  w1[hook(25, lid)] = sum;

  barrier(0x01);

  if (lid == 0) {
    for (i = 1; i < 16; i++) {
      w1[hook(25, 0)] += w1[hook(25, i)];
    }
  }

  barrier(0x01);
}

void vecisEqual(local int* w1, local float4* v1, local float4* v2, int lid) {
  int i = lid * 4;
  int sum = 0;

  sum += all(isnotequal(v1[hook(23, i)], v2[hook(24, i)]));
  sum += all(isnotequal(v1[hook(23, i + 1)], v2[hook(24, i + 1)]));
  sum += all(isnotequal(v1[hook(23, i + 2)], v2[hook(24, i + 2)]));
  sum += all(isnotequal(v1[hook(23, i + 3)], v2[hook(24, i + 3)]));
  w1[hook(25, lid)] = sum;

  barrier(0x01);

  if (lid == 0) {
    for (i = 1; i < 16; i++) {
      w1[hook(25, 0)] += w1[hook(25, i)];
    }
    w1[hook(25, 0)] = !w1[hook(25, 0)];
  }

  barrier(0x01);
}

void vecfma(local float4* v1, local float4* v2, local float4* v3, float s1, int lid) {
  int i = lid * 4;

  float4 t1 = (float4)(s1, s1, s1, s1);
  v1[hook(23, i)] = fma(t1, v2[hook(24, i)], v3[hook(26, i)]);
  v1[hook(23, i + 1)] = fma(t1, v2[hook(24, i + 1)], v3[hook(26, i + 1)]);
  v1[hook(23, i + 2)] = fma(t1, v2[hook(24, i + 2)], v3[hook(26, i + 2)]);
  v1[hook(23, i + 3)] = fma(t1, v2[hook(24, i + 3)], v3[hook(26, i + 3)]);
}

void vecfmaInplace(local float4* v1, local float4* v2, float s1, int lid) {
  int i = lid * 4;

  float4 t1 = (float4)(s1, s1, s1, s1);
  v1[hook(23, i)] = fma(t1, v2[hook(24, i)], v1[hook(23, i)]);
  v1[hook(23, i + 1)] = fma(t1, v2[hook(24, i + 1)], v1[hook(23, i + 1)]);
  v1[hook(23, i + 2)] = fma(t1, v2[hook(24, i + 2)], v1[hook(23, i + 2)]);
  v1[hook(23, i + 3)] = fma(t1, v2[hook(24, i + 3)], v1[hook(23, i + 3)]);
}

void vecnorm(local float* w1, local float4* v1, int lid) {
  vecdot(w1, v1, v1, lid);

  if (lid == 0) {
    w1[hook(25, 0)] = sqrt(w1[hook(25, 0)]);
  }

  barrier(0x01);
}

void vecscaleInplace(local float4* v1, float s1, int lid) {
  int i = lid * 4;

  float4 t1 = (float4)(s1, s1, s1, s1);
  v1[hook(23, i)] = v1[hook(23, i)] * t1;
  v1[hook(23, i + 1)] = v1[hook(23, i + 1)] * t1;
  v1[hook(23, i + 2)] = v1[hook(23, i + 2)] * t1;
  v1[hook(23, i + 3)] = v1[hook(23, i + 3)] * t1;
}

void vecsub(local float4* v1, local float4* v2, local float4* v3, int lid) {
  int i = lid * 4;

  v1[hook(23, i)] = v2[hook(24, i)] - v3[hook(26, i)];
  v1[hook(23, i + 1)] = v2[hook(24, i + 1)] - v3[hook(26, i + 1)];
  v1[hook(23, i + 2)] = v2[hook(24, i + 2)] - v3[hook(26, i + 2)];
  v1[hook(23, i + 3)] = v2[hook(24, i + 3)] - v3[hook(26, i + 3)];
}
void calcLLGradient(local float4* u, local float4* data, local float4* gamma, local float4* gradient, int lid) {
  int i = lid * 4;
  float4 t1;
  float4 t2;

  t1 = data[hook(27, i)] + gamma[hook(28, i)];
  t2 = fmax(u[hook(29, i)] + gamma[hook(28, i)], 1.0e-6f);
  gradient[hook(30, i)] = 1.0f - t1 / t2;

  i += 1;
  t1 = data[hook(27, i)] + gamma[hook(28, i)];
  t2 = fmax(u[hook(29, i)] + gamma[hook(28, i)], 1.0e-6f);
  gradient[hook(30, i)] = 1.0f - t1 / t2;

  i += 1;
  t1 = data[hook(27, i)] + gamma[hook(28, i)];
  t2 = fmax(u[hook(29, i)] + gamma[hook(28, i)], 1.0e-6f);
  gradient[hook(30, i)] = 1.0f - t1 / t2;

  i += 1;
  t1 = data[hook(27, i)] + gamma[hook(28, i)];
  t2 = fmax(u[hook(29, i)] + gamma[hook(28, i)], 1.0e-6f);
  gradient[hook(30, i)] = 1.0f - t1 / t2;
}

void calcLogLikelihood(local float* w1, local float4* u, local float4* data, local float4* gamma, int lid) {
  int i = lid * 4;
  float4 sum = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float4 t1;
  float4 t2;

  t1 = data[hook(27, i)] + gamma[hook(28, i)];
  t2 = log(fmax(u[hook(29, i)] + gamma[hook(28, i)], 1.0e-6f));
  sum += u[hook(29, i)] - t1 * t2;

  i += 1;
  t1 = data[hook(27, i)] + gamma[hook(28, i)];
  t2 = log(fmax(u[hook(29, i)] + gamma[hook(28, i)], 1.0e-6f));
  sum += u[hook(29, i)] - t1 * t2;

  i += 1;
  t1 = data[hook(27, i)] + gamma[hook(28, i)];
  t2 = log(fmax(u[hook(29, i)] + gamma[hook(28, i)], 1.0e-6f));
  sum += u[hook(29, i)] - t1 * t2;

  i += 1;
  t1 = data[hook(27, i)] + gamma[hook(28, i)];
  t2 = log(fmax(u[hook(29, i)] + gamma[hook(28, i)], 1.0e-6f));
  sum += u[hook(29, i)] - t1 * t2;

  w1[hook(25, lid)] = sum.x + sum.y + sum.z + sum.w;

  barrier(0x01);

  if (lid == 0) {
    for (i = 1; i < 16; i++) {
      w1[hook(25, 0)] += w1[hook(25, i)];
    }
  }

  barrier(0x01);
}
void calcNCGradientIFFT(local float4* w1, local float4* w2, local float4* w3, local float4* u_fft_r, local float4* u_fft_c, local float4* otf_mask_sqr, local float4* gradient, int lid) {
  int i = lid * 4;

  float4 t1;

  t1 = 2.0f * otf_mask_sqr[hook(31, i)];
  w1[hook(25, i)] = t1 * u_fft_r[hook(32, i)];
  w2[hook(33, i)] = t1 * u_fft_c[hook(34, i)];

  i += 1;
  t1 = 2.0f * otf_mask_sqr[hook(31, i)];
  w1[hook(25, i)] = t1 * u_fft_r[hook(32, i)];
  w2[hook(33, i)] = t1 * u_fft_c[hook(34, i)];

  i += 1;
  t1 = 2.0f * otf_mask_sqr[hook(31, i)];
  w1[hook(25, i)] = t1 * u_fft_r[hook(32, i)];
  w2[hook(33, i)] = t1 * u_fft_c[hook(34, i)];

  i += 1;
  t1 = 2.0f * otf_mask_sqr[hook(31, i)];
  w1[hook(25, i)] = t1 * u_fft_r[hook(32, i)];
  w2[hook(33, i)] = t1 * u_fft_c[hook(34, i)];

  barrier(0x01);

  ifft_16x16_wg16(w1, w2, gradient, w3, lid);
}

void calcNoiseContribution(local float* w1, local float4* u_fft_r, local float4* u_fft_c, local float4* otf_mask_sqr, int lid) {
  int i = lid * 4;
  float4 sum = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float4 t1;

  t1 = u_fft_r[hook(32, i)] * u_fft_r[hook(32, i)] + u_fft_c[hook(34, i)] * u_fft_c[hook(34, i)];
  sum += t1 * otf_mask_sqr[hook(31, i)];

  i += 1;
  t1 = u_fft_r[hook(32, i)] * u_fft_r[hook(32, i)] + u_fft_c[hook(34, i)] * u_fft_c[hook(34, i)];
  sum += t1 * otf_mask_sqr[hook(31, i)];

  i += 1;
  t1 = u_fft_r[hook(32, i)] * u_fft_r[hook(32, i)] + u_fft_c[hook(34, i)] * u_fft_c[hook(34, i)];
  sum += t1 * otf_mask_sqr[hook(31, i)];

  i += 1;
  t1 = u_fft_r[hook(32, i)] * u_fft_r[hook(32, i)] + u_fft_c[hook(34, i)] * u_fft_c[hook(34, i)];
  sum += t1 * otf_mask_sqr[hook(31, i)];

  w1[hook(25, lid)] = sum.x + sum.y + sum.z + sum.w;

  barrier(0x01);

  if (lid == 0) {
    for (i = 1; i < 16; i++) {
      w1[hook(25, 0)] += w1[hook(25, i)];
    }
    w1[hook(25, 0)] = w1[hook(25, 0)] * (1.0f / (4.0f * 64));
  }

  barrier(0x01);
}

void converged(local int* w1, local float* w2, local float4* x, local float4* g, int lid) {
  float xnorm;
  float gnorm;

  vecnorm(w2, x, lid);
  if (lid == 0) {
    xnorm = fmax(w2[hook(33, 0)], 1.0f);
  }

  barrier(0x01);

  vecnorm(w2, g, lid);
  if (lid == 0) {
    gnorm = w2[hook(33, 0)];
    if ((gnorm / xnorm) > 1.0e-4f) {
      w1[hook(25, 0)] = 0;
    } else {
      w1[hook(25, 0)] = 1;
    }
  }

  barrier(0x01);
}
kernel void ncsReduceNoise(global float4* data_in, global float4* g_gamma, global float4* otf_mask, global float4* data_out, global int* g_iterations, global int* g_status, float alpha)

{
  int gid = get_group_id(0);
  int lid = get_local_id(0);

  int i = lid * 4;
  int i_g = gid * 64;

  int j, k;

  local int bound;
  local int ci;
  local int searching;

  local float beta;
  local float cost;
  local float cost_p;
  local float step;
  local float t1;
  local float ys_c0;
  local float yy;

  local int w1_i[16];
  local float w1_f[16];

  local float a[8];
  local float ys[8];

  local float4 data[64];
  local float4 gamma[64];
  local float4 g_p[64];
  local float4 gradient[64];
  local float4 otf_mask_sqr[64];
  local float4 srch_dir[64];
  local float4 u_c[64];
  local float4 u_p[64];
  local float4 u_r[64];
  local float4 u_fft_r[64];
  local float4 u_fft_c[64];

  local float4 w1_f4[64];
  local float4 w2_f4[64];
  local float4 w3_f4[64];
  local float4 w4_f4[64];

  local float4 s[8][64];
  local float4 y[8][64];

  for (j = 0; j < 4; j++) {
    k = i + j;
    data[hook(27, k)] = data_in[hook(0, i_g + k)];
    gamma[hook(28, k)] = g_gamma[hook(1, i_g + k)];
    otf_mask_sqr[hook(31, k)] = otf_mask[hook(2, k)] * otf_mask[hook(2, k)];
    u_r[hook(35, k)] = data_in[hook(0, i_g + k)];
    u_c[hook(36, k)] = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  }

  barrier(0x01);

  fft_16x16_wg16(u_r, u_c, u_fft_r, u_fft_c, lid);

  calcLogLikelihood(w1_f, u_r, data, gamma, lid);
  if (lid == 0) {
    cost = w1_f[hook(37, 0)];
  }

  barrier(0x01);

  calcNoiseContribution(w1_f, u_fft_r, u_fft_c, otf_mask_sqr, lid);
  if (lid == 0) {
    cost += alpha * w1_f[hook(37, 0)];
  }

  barrier(0x01);

  calcLLGradient(u_r, data, gamma, gradient, lid);
  calcNCGradientIFFT(w1_f4, w2_f4, w3_f4, u_fft_r, u_fft_c, otf_mask_sqr, w4_f4, lid);
  vecfmaInplace(gradient, w4_f4, alpha, lid);

  barrier(0x01);

  converged(w1_i, w1_f, u_r, gradient, lid);
  if (w1_i[hook(38, 0)]) {
    if (lid == 0) {
      g_iterations[hook(4, gid)] = 1;
      g_status[hook(5, gid)] = 0;
    }
    for (j = 0; j < 4; j++) {
      k = i + j;
      data_out[hook(3, i_g + k)] = u_r[hook(35, k)];
    }
    return;
  }

  vecnorm(w1_f, gradient, lid);
  if (lid == 0) {
    step = 1.0 / w1_f[hook(37, 0)];
  }
  vecncopy(srch_dir, gradient, lid);

  barrier(0x01);

  for (k = 1; k < (200 + 1); k++) {
    vecdot(w1_f, srch_dir, gradient, lid);
    if (lid == 0) {
      t1 = 1.0e-4f * w1_f[hook(37, 0)];
    }

    barrier(0x01);

    if (t1 > 0.0) {
      if (lid == 0) {
        g_iterations[hook(4, gid)] = k;
        g_status[hook(5, gid)] = -3;
      }
      for (j = 0; j < 4; j++) {
        k = i + j;
        data_out[hook(3, i_g + k)] = u_r[hook(35, k)];
      }
      return;
    }

    if (lid == 0) {
      cost_p = cost;
    }
    veccopy(u_p, u_r, lid);
    veccopy(g_p, gradient, lid);

    if (lid == 0) {
      searching = 1;
    }

    barrier(0x01);

    while (searching) {
      vecfma(u_r, srch_dir, u_p, step, lid);

      barrier(0x01);

      fft_16x16_wg16(u_r, u_c, u_fft_r, u_fft_c, lid);

      calcLogLikelihood(w1_f, u_r, data, gamma, lid);
      if (lid == 0) {
        cost = w1_f[hook(37, 0)];
      }

      barrier(0x01);

      calcNoiseContribution(w1_f, u_fft_r, u_fft_c, otf_mask_sqr, lid);
      if (lid == 0) {
        cost += alpha * w1_f[hook(37, 0)];
      }

      barrier(0x01);

      if (cost <= (cost_p + t1 * step)) {
        if (lid == 0) {
          searching = 0;
        }

        barrier(0x01);

      } else {
        if (lid == 0) {
          step = 0.5 * step;
        }

        barrier(0x01);

        if (step < 1.0e-6f) {
          if (lid == 0) {
            g_iterations[hook(4, gid)] = k + 1;
            g_status[hook(5, gid)] = -4;
          }
          for (j = 0; j < 4; j++) {
            k = i + j;
            data_out[hook(3, i_g + k)] = u_p[hook(39, k)];
          }
          return;
        }
      }
    }

    calcLLGradient(u_r, data, gamma, gradient, lid);
    calcNCGradientIFFT(w1_f4, w2_f4, w3_f4, u_fft_r, u_fft_c, otf_mask_sqr, w4_f4, lid);
    vecfmaInplace(gradient, w4_f4, alpha, lid);

    barrier(0x01);

    converged(w1_i, w1_f, u_r, gradient, lid);
    if (w1_i[hook(38, 0)]) {
      if (lid == 0) {
        g_iterations[hook(4, gid)] = k + 1;
        g_status[hook(5, gid)] = 0;
      }
      for (j = 0; j < 4; j++) {
        k = i + j;
        data_out[hook(3, i_g + k)] = u_r[hook(35, k)];
      }
      return;
    }

    vecisEqual(w1_i, u_r, u_p, lid);
    if (w1_i[hook(38, 0)]) {
      if (lid == 0) {
        g_iterations[hook(4, gid)] = k + 1;
        g_status[hook(5, gid)] = -5;
      }
      for (j = 0; j < 4; j++) {
        k = i + j;
        data_out[hook(3, i_g + k)] = u_r[hook(35, k)];
      }
      return;
    }

    if (lid == 0) {
      ci = (k - 1) % 8;
    }

    barrier(0x01);

    vecsub(s[hook(40, ci)], u_r, u_p, lid);
    vecsub(y[hook(41, ci)], gradient, g_p, lid);

    barrier(0x01);

    vecdot(w1_f, s[hook(40, ci)], y[hook(41, ci)], lid);
    if (lid == 0) {
      ys_c0 = w1_f[hook(37, 0)];
      ys[hook(42, ci)] = 1.0 / ys_c0;
    }

    barrier(0x01);

    vecdot(w1_f, y[hook(41, ci)], y[hook(41, ci)], lid);
    if (lid == 0) {
      yy = 1.0 / w1_f[hook(37, 0)];
    }

    vecncopy(srch_dir, gradient, lid);

    if (lid == 0) {
      bound = min(k, 8);
    }

    barrier(0x01);

    for (j = 0; j < bound; j++) {
      if (lid == 0) {
        ci = (k - j - 1) % 8;
      }

      barrier(0x01);

      vecdot(w1_f, s[hook(40, ci)], srch_dir, lid);
      if (lid == 0) {
        a[hook(43, ci)] = w1_f[hook(37, 0)] * ys[hook(42, ci)];
      }

      barrier(0x01);

      vecfmaInplace(srch_dir, y[hook(41, ci)], -a[hook(43, ci)], lid);
    }

    vecscaleInplace(srch_dir, ys_c0 * yy, lid);

    for (j = 0; j < bound; j++) {
      if (lid == 0) {
        ci = (k + j - bound) % 8;
      }

      barrier(0x01);

      vecdot(w1_f, y[hook(41, ci)], srch_dir, lid);
      if (lid == 0) {
        beta = w1_f[hook(37, 0)] * ys[hook(42, ci)];
      }

      barrier(0x01);

      vecfmaInplace(srch_dir, s[hook(40, ci)], (a[hook(43, ci)] - beta), lid);
    }

    if (lid == 0) {
      step = 1.0;
    }

    barrier(0x01);
  }

  if (lid == 0) {
    g_iterations[hook(4, gid)] = 200;
    g_status[hook(5, gid)] = -2;
  }
  for (j = 0; j < 4; j++) {
    k = i + j;
    data_out[hook(3, i_g + k)] = u_r[hook(35, k)];
  }
}