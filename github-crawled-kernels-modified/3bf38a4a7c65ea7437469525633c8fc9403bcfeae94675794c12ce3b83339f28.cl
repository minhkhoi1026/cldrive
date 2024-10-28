//{"angle_scale":8,"cnbins":10,"correct_gamma":9,"grad":6,"grad_quadstep":3,"height":0,"img":5,"img_step":2,"qangle":7,"qangle_step":4,"row":13,"sh_row":12,"smem":11,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float reduce_smem(volatile local float* smem, int size) {
  unsigned int tid = get_local_id(0);
  float sum = smem[hook(11, tid)];

  if (size >= 512) {
    if (tid < 256)
      smem[hook(11, tid)] = sum = sum + smem[hook(11, tid + 256)];
    barrier(0x01);
  }
  if (size >= 256) {
    if (tid < 128)
      smem[hook(11, tid)] = sum = sum + smem[hook(11, tid + 128)];
    barrier(0x01);
  }
  if (size >= 128) {
    if (tid < 64)
      smem[hook(11, tid)] = sum = sum + smem[hook(11, tid + 64)];
    barrier(0x01);
  }
  if (tid < 32) {
    if (size >= 64)
      smem[hook(11, tid)] = sum = sum + smem[hook(11, tid + 32)];
  }
  barrier(0x01);
  if (tid < 16) {
    if (size >= 32)
      smem[hook(11, tid)] = sum = sum + smem[hook(11, tid + 16)];
    if (size >= 16)
      smem[hook(11, tid)] = sum = sum + smem[hook(11, tid + 8)];
    if (size >= 8)
      smem[hook(11, tid)] = sum = sum + smem[hook(11, tid + 4)];
    if (size >= 4)
      smem[hook(11, tid)] = sum = sum + smem[hook(11, tid + 2)];
    if (size >= 2)
      smem[hook(11, tid)] = sum = sum + smem[hook(11, tid + 1)];
  }

  return sum;
}

kernel void compute_gradients_8UC1_kernel(const int height, const int width, const int img_step, const int grad_quadstep, const int qangle_step, global const uchar* img, global float* grad, global uchar* qangle, const float angle_scale, const char correct_gamma, const int cnbins) {
  const int x = get_global_id(0);
  const int tid = get_local_id(0);
  const int gSizeX = get_local_size(0);
  const int gidY = get_group_id(1);

  global const uchar* row = img + gidY * img_step;

  local float sh_row[256 + 2];

  if (x < width)
    sh_row[hook(12, tid + 1)] = row[hook(13, x)];
  else
    sh_row[hook(12, tid + 1)] = row[hook(13, width - 2)];

  if (tid == 0)
    sh_row[hook(12, 0)] = row[hook(13, max(x - 1, 1))];

  if (tid == gSizeX - 1)
    sh_row[hook(12, gSizeX + 1)] = row[hook(13, min(x + 1, width - 2))];

  barrier(0x01);
  if (x < width) {
    float dx;

    if (correct_gamma == 1)
      dx = sqrt(sh_row[hook(12, tid + 2)]) - sqrt(sh_row[hook(12, tid)]);
    else
      dx = sh_row[hook(12, tid + 2)] - sh_row[hook(12, tid)];

    float dy = 0.f;
    if (gidY > 0 && gidY < height - 1) {
      float a = (float)img[hook(5, (gidY + 1) * img_step + x)];
      float b = (float)img[hook(5, (gidY - 1) * img_step + x)];
      if (correct_gamma == 1)
        dy = sqrt(a) - sqrt(b);
      else
        dy = a - b;
    }
    float mag = hypot(dx, dy);

    float ang = (atan2(dy, dx) + 3.14159265358979323846264338327950288f) * angle_scale - 0.5f;
    int hidx = (int)floor(ang);
    ang -= hidx;
    hidx = (hidx + cnbins) % cnbins;

    qangle[hook(7, (gidY * qangle_step + x) << 1)] = hidx;
    qangle[hook(7, ((gidY * qangle_step + x) << 1) + 1)] = (hidx + 1) % cnbins;
    grad[hook(6, (gidY * grad_quadstep + x) << 1)] = mag * (1.f - ang);
    grad[hook(6, ((gidY * grad_quadstep + x) << 1) + 1)] = mag * ang;
  }
}