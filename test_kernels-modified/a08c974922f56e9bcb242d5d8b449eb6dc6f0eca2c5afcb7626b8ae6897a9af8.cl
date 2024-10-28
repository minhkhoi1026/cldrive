//{"data2":0,"ldata":3,"maximum":1,"minimum":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void max_min_global_stage2(global const float2* data2, global float* maximum, global float* minimum) {
  local float2 ldata[256];
  unsigned int lid = get_local_id(0);
  unsigned int group_size = min((unsigned int)get_local_size(0), (unsigned int)256);
  float2 acc = (float2)(-1.0f, -1.0f);
  if (lid <= group_size) {
    ldata[hook(3, lid)] = data2[hook(0, lid)];
  } else {
    ldata[hook(3, lid)] = acc;
  }
  barrier(0x01);

  if ((lid < group_size) && (lid < 512) && ((lid + 512) < group_size)) {
    ldata[hook(3, lid)] = ((float2)(fmax(ldata[hook(3, lid)].x, ldata[hook(3, lid + 512)].x), fmin(ldata[hook(3, lid)].y, ldata[hook(3, lid + 512)].y)));
  }
  barrier(0x01);
  if ((lid < group_size) && (lid < 256) && ((lid + 256) < group_size)) {
    ldata[hook(3, lid)] = ((float2)(fmax(ldata[hook(3, lid)].x, ldata[hook(3, lid + 256)].x), fmin(ldata[hook(3, lid)].y, ldata[hook(3, lid + 256)].y)));
  }
  barrier(0x01);
  if ((lid < group_size) && (lid < 128) && ((lid + 128) < group_size)) {
    ldata[hook(3, lid)] = ((float2)(fmax(ldata[hook(3, lid)].x, ldata[hook(3, lid + 128)].x), fmin(ldata[hook(3, lid)].y, ldata[hook(3, lid + 128)].y)));
  }
  barrier(0x01);
  if ((lid < group_size) && (lid < 64) && ((lid + 64) < group_size)) {
    ldata[hook(3, lid)] = ((float2)(fmax(ldata[hook(3, lid)].x, ldata[hook(3, lid + 64)].x), fmin(ldata[hook(3, lid)].y, ldata[hook(3, lid + 64)].y)));
  }
  barrier(0x01);
  if ((lid < group_size) && (lid < 32) && ((lid + 32) < group_size)) {
    ldata[hook(3, lid)] = ((float2)(fmax(ldata[hook(3, lid)].x, ldata[hook(3, lid + 32)].x), fmin(ldata[hook(3, lid)].y, ldata[hook(3, lid + 32)].y)));
  }
  barrier(0x01);
  if ((lid < group_size) && (lid < 16) && ((lid + 16) < group_size)) {
    ldata[hook(3, lid)] = ((float2)(fmax(ldata[hook(3, lid)].x, ldata[hook(3, lid + 16)].x), fmin(ldata[hook(3, lid)].y, ldata[hook(3, lid + 16)].y)));
  }
  barrier(0x01);
  if ((lid < group_size) && (lid < 8) && ((lid + 8) < group_size)) {
    ldata[hook(3, lid)] = ((float2)(fmax(ldata[hook(3, lid)].x, ldata[hook(3, lid + 8)].x), fmin(ldata[hook(3, lid)].y, ldata[hook(3, lid + 8)].y)));
  }
  barrier(0x01);
  if ((lid < group_size) && (lid < 4) && ((lid + 4) < group_size)) {
    ldata[hook(3, lid)] = ((float2)(fmax(ldata[hook(3, lid)].x, ldata[hook(3, lid + 4)].x), fmin(ldata[hook(3, lid)].y, ldata[hook(3, lid + 4)].y)));
  }
  barrier(0x01);
  if ((lid < group_size) && (lid < 2) && ((lid + 2) < group_size)) {
    ldata[hook(3, lid)] = ((float2)(fmax(ldata[hook(3, lid)].x, ldata[hook(3, lid + 2)].x), fmin(ldata[hook(3, lid)].y, ldata[hook(3, lid + 2)].y)));
  }
  barrier(0x01);

  if (lid == 0) {
    if (1 < group_size) {
      acc = ((float2)(fmax(ldata[hook(3, 0)].x, ldata[hook(3, 1)].x), fmin(ldata[hook(3, 0)].y, ldata[hook(3, 1)].y)));
    } else {
      acc = ldata[hook(3, 0)];
    }
    maximum[hook(1, 0)] = acc.x;
    minimum[hook(2, 0)] = acc.y;
  }
}