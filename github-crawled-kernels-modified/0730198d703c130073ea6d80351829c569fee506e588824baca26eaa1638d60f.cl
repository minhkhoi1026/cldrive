//{"angle_scale":8,"cnbins":10,"correct_gamma":9,"grad":6,"grad_quadstep":3,"height":0,"img":5,"img_step":2,"qangle":7,"qangle_step":4,"row":12,"sh_row":13,"smem":11,"width":1}
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

kernel void compute_gradients_8UC4_kernel(const int height, const int width, const int img_step, const int grad_quadstep, const int qangle_step, const global uchar4* img, global float* grad, global uchar* qangle, const float angle_scale, const char correct_gamma, const int cnbins) {
  const int x = get_global_id(0);
  const int tid = get_local_id(0);
  const int gSizeX = get_local_size(0);
  const int gidY = get_group_id(1);

  global const uchar4* row = img + gidY * img_step;

  local float sh_row[(256 + 2) * 3];

  uchar4 val;
  if (x < width)
    val = row[hook(12, x)];
  else
    val = row[hook(12, width - 2)];

  sh_row[hook(13, tid + 1)] = val.x;
  sh_row[hook(13, tid + 1 + (256 + 2))] = val.y;
  sh_row[hook(13, tid + 1 + 2 * (256 + 2))] = val.z;

  if (tid == 0) {
    val = row[hook(12, max(x - 1, 1))];
    sh_row[hook(13, 0)] = val.x;
    sh_row[hook(13, (256 + 2))] = val.y;
    sh_row[hook(13, 2 * (256 + 2))] = val.z;
  }

  if (tid == gSizeX - 1) {
    val = row[hook(12, min(x + 1, width - 2))];
    sh_row[hook(13, gSizeX + 1)] = val.x;
    sh_row[hook(13, gSizeX + 1 + (256 + 2))] = val.y;
    sh_row[hook(13, gSizeX + 1 + 2 * (256 + 2))] = val.z;
  }

  barrier(0x01);
  if (x < width) {
    float4 a = (float4)(sh_row[hook(13, tid)], sh_row[hook(13, tid + (256 + 2))], sh_row[hook(13, tid + 2 * (256 + 2))], 0);
    float4 b = (float4)(sh_row[hook(13, tid + 2)], sh_row[hook(13, tid + 2 + (256 + 2))], sh_row[hook(13, tid + 2 + 2 * (256 + 2))], 0);

    float4 dx;
    if (correct_gamma == 1)
      dx = sqrt(b) - sqrt(a);
    else
      dx = b - a;

    float4 dy = (float4)0.f;

    if (gidY > 0 && gidY < height - 1) {
      a = convert_float4(img[hook(5, (gidY - 1) * img_step + x)].xyzw);
      b = convert_float4(img[hook(5, (gidY + 1) * img_step + x)].xyzw);

      if (correct_gamma == 1)
        dy = sqrt(b) - sqrt(a);
      else
        dy = b - a;
    }

    float4 mag = hypot(dx, dy);
    float best_dx = dx.x;
    float best_dy = dy.x;

    float mag0 = mag.x;
    if (mag0 < mag.y) {
      best_dx = dx.y;
      best_dy = dy.y;
      mag0 = mag.y;
    }

    if (mag0 < mag.z) {
      best_dx = dx.z;
      best_dy = dy.z;
      mag0 = mag.z;
    }

    float ang = (atan2(best_dy, best_dx) + 3.14159265358979323846264338327950288f) * angle_scale - 0.5f;
    int hidx = (int)floor(ang);
    ang -= hidx;
    hidx = (hidx + cnbins) % cnbins;

    qangle[hook(7, (gidY * qangle_step + x) << 1)] = hidx;
    qangle[hook(7, ((gidY * qangle_step + x) << 1) + 1)] = (hidx + 1) % cnbins;
    grad[hook(6, (gidY * grad_quadstep + x) << 1)] = mag0 * (1.f - ang);
    grad[hook(6, ((gidY * grad_quadstep + x) << 1) + 1)] = mag0 * ang;
  }
}