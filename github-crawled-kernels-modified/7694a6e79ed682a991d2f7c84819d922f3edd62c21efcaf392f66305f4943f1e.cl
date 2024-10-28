//{"buffer":6,"coord_buf":7,"img_height":5,"img_width":4,"nb_pixels":8,"result":1,"result_coord":2,"source":0,"src_step":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void atomic_minf_1(global float* result, float value, int nb_pixels) {
  global int* intPtr = (global int*)result;
  bool ExchangeDone = false;
  while (!ExchangeDone) {
    float V = *result;
    float NewValue = min(V, value);
    int intResult = atomic_cmpxchg(intPtr, __builtin_astype((V), int), __builtin_astype((NewValue), int));
    float Result = __builtin_astype((intResult), float);
    ExchangeDone = (V == Result);
  }
}
void atomic_maxf_1(global float* result, float value, int nb_pixels) {
  global int* intPtr = (global int*)result;
  bool ExchangeDone = false;
  while (!ExchangeDone) {
    float V = *result;
    float NewValue = max(V, value);
    int intResult = atomic_cmpxchg(intPtr, __builtin_astype((V), int), __builtin_astype((NewValue), int));
    float Result = __builtin_astype((intResult), float);
    ExchangeDone = (V == Result);
  }
}

void atomic_minf_2(global float* result, uchar2 value, int nb_pixels) {
  atomic_minf_1(result + 0, value.x, nb_pixels);
  atomic_minf_1(result + 1, value.y, nb_pixels);
}
void atomic_maxf_2(global float* result, uchar2 value, int nb_pixels) {
  atomic_maxf_1(result + 0, value.x, nb_pixels);
  atomic_maxf_1(result + 1, value.y, nb_pixels);
}
void atomic_minf_3(global float* result, uchar3 value, int nb_pixels) {
  atomic_minf_1(result + 0, value.x, nb_pixels);
  atomic_minf_1(result + 1, value.y, nb_pixels);
  atomic_minf_1(result + 2, value.z, nb_pixels);
}
void atomic_maxf_3(global float* result, uchar3 value, int nb_pixels) {
  atomic_maxf_1(result + 0, value.x, nb_pixels);
  atomic_maxf_1(result + 1, value.y, nb_pixels);
  atomic_maxf_1(result + 2, value.z, nb_pixels);
}
void atomic_minf_4(global float* result, uchar4 value, int nb_pixels) {
  atomic_minf_1(result + 0, value.x, nb_pixels);
  atomic_minf_1(result + 1, value.y, nb_pixels);
  atomic_minf_1(result + 2, value.z, nb_pixels);
  atomic_minf_1(result + 3, value.w, nb_pixels);
}
void atomic_maxf_4(global float* result, uchar4 value, int nb_pixels) {
  atomic_maxf_1(result + 0, value.x, nb_pixels);
  atomic_maxf_1(result + 1, value.y, nb_pixels);
  atomic_maxf_1(result + 2, value.z, nb_pixels);
  atomic_maxf_1(result + 3, value.w, nb_pixels);
}
void store_value(global float* buffer, float value, int nb_pixels) {
  const int gid = get_group_id(1) * get_num_groups(0) + get_group_id(0);

  global float* result_buffer = (global float*)(buffer + gid * 4);
  *result_buffer = value;

  const int offset = get_num_groups(0) * get_num_groups(1);
  buffer[hook(6, offset * 4 + gid)] = nb_pixels;
}
__attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) kernel void max_abs_coord(global const uchar* source, global float* result, global int2* result_coord, int src_step, int img_width, int img_height) {
  local uchar buffer[(16 * 16)];
  local int2 coord_buf[(16 * 16)];
  local char nb_pixels[(16 * 16)];
  int gx1 = get_global_id(0);
  const int gx = (gx1 & (16 - 1)) + (gx1 >> 4) * 16 * 16;
  const int gy = get_global_id(1);
  const int lid = get_local_id(1) * get_local_size(0) + get_local_id(0);
  src_step /= sizeof(uchar);
  if (gx < img_width && gy < img_height) {
    uchar Res = abs(source[hook(0, (gy * src_step) + gx + 0)]);
    int2 coord = (int2)(gx, gy);
    int Nb = 1;
    for (int i = 16; i < 16 * 16; i += 16)
      if (gx + i < img_width) {
        uchar px = abs(source[hook(0, (gy * src_step) + gx + i)]);
        if (px > Res) {
          Res = px;
          coord.x = gx + i;
        }
      }
    buffer[hook(6, lid)] = Res;
    coord_buf[hook(7, lid)] = coord;
    nb_pixels[hook(8, lid)] = 1;
  } else
    nb_pixels[hook(8, lid)] = 0;
  barrier(0x01);
  if (lid < 128)
    if (nb_pixels[hook(8, lid)] && nb_pixels[hook(8, lid + 128)]) {
      if (buffer[hook(6, lid + 128)] > buffer[hook(6, lid)]) {
        buffer[hook(6, lid)] = buffer[hook(6, lid + 128)];
        coord_buf[hook(7, lid)] = coord_buf[hook(7, lid + 128)];
      }
    };
  barrier(0x01);
  if (lid < 64)
    if (nb_pixels[hook(8, lid)] && nb_pixels[hook(8, lid + 64)]) {
      if (buffer[hook(6, lid + 64)] > buffer[hook(6, lid)]) {
        buffer[hook(6, lid)] = buffer[hook(6, lid + 64)];
        coord_buf[hook(7, lid)] = coord_buf[hook(7, lid + 64)];
      }
    };
  barrier(0x01);
  if (lid < 32)
    if (nb_pixels[hook(8, lid)] && nb_pixels[hook(8, lid + 32)]) {
      if (buffer[hook(6, lid + 32)] > buffer[hook(6, lid)]) {
        buffer[hook(6, lid)] = buffer[hook(6, lid + 32)];
        coord_buf[hook(7, lid)] = coord_buf[hook(7, lid + 32)];
      }
    };
  barrier(0x01);
  if (lid < 16)
    if (nb_pixels[hook(8, lid)] && nb_pixels[hook(8, lid + 16)]) {
      if (buffer[hook(6, lid + 16)] > buffer[hook(6, lid)]) {
        buffer[hook(6, lid)] = buffer[hook(6, lid + 16)];
        coord_buf[hook(7, lid)] = coord_buf[hook(7, lid + 16)];
      }
    };
  barrier(0x01);
  if (lid < 8)
    if (nb_pixels[hook(8, lid)] && nb_pixels[hook(8, lid + 8)]) {
      if (buffer[hook(6, lid + 8)] > buffer[hook(6, lid)]) {
        buffer[hook(6, lid)] = buffer[hook(6, lid + 8)];
        coord_buf[hook(7, lid)] = coord_buf[hook(7, lid + 8)];
      }
    };
  barrier(0x01);
  if (lid < 4)
    if (nb_pixels[hook(8, lid)] && nb_pixels[hook(8, lid + 4)]) {
      if (buffer[hook(6, lid + 4)] > buffer[hook(6, lid)]) {
        buffer[hook(6, lid)] = buffer[hook(6, lid + 4)];
        coord_buf[hook(7, lid)] = coord_buf[hook(7, lid + 4)];
      }
    };
  barrier(0x01);
  if (lid < 2)
    if (nb_pixels[hook(8, lid)] && nb_pixels[hook(8, lid + 2)]) {
      if (buffer[hook(6, lid + 2)] > buffer[hook(6, lid)]) {
        buffer[hook(6, lid)] = buffer[hook(6, lid + 2)];
        coord_buf[hook(7, lid)] = coord_buf[hook(7, lid + 2)];
      }
    };
  barrier(0x01);
  if (lid == 0) {
    if (nb_pixels[hook(8, 0)] && nb_pixels[hook(8, 1)]) {
      if (buffer[hook(6, 1)] > buffer[hook(6, 0)]) {
        buffer[hook(6, 0)] = buffer[hook(6, 1)];
        coord_buf[hook(7, 0)] = coord_buf[hook(7, 1)];
      }
    };
    const int gid = get_group_id(1) * get_num_groups(0) + get_group_id(0);
    result[hook(1, gid)] = buffer[hook(6, 0)];
    result_coord[hook(2, gid)] = coord_buf[hook(7, 0)];
  }
}