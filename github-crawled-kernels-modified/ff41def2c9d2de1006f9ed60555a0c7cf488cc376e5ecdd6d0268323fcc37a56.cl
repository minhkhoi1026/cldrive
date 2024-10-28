//{"buffer":5,"img_height":4,"img_width":3,"nb_pixels":6,"result":1,"source":0,"src_step":2}
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
  buffer[hook(5, offset * 4 + gid)] = nb_pixels;
}
__attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) kernel void reduce_max(global const uchar* source, global float* result, int src_step, int img_width, int img_height) {
  local uchar buffer[(16 * 16)];
  local int nb_pixels[(16 * 16)];
  int gx1 = get_global_id(0);
  const int gx = (gx1 & (16 - 1)) + (gx1 >> 4) * 16 * 16;
  const int gy = get_global_id(1);
  const int lid = get_local_id(1) * get_local_size(0) + get_local_id(0);
  src_step /= sizeof(uchar);
  float Weight;
  if (gx < img_width && gy < img_height) {
    uchar Res = convert_uchar(source[hook(0, (gy * src_step) + gx + 0)]);
    Res = Res;
    int Nb = 1;
    for (int i = 16; i < 16 * 16; i += 16)
      if (gx + i < img_width) {
        uchar px = convert_uchar(source[hook(0, (gy * src_step) + gx + i)]);
        Res = max(Res, px);
        Nb++;
      }
    buffer[hook(5, lid)] = Res;
    nb_pixels[hook(6, lid)] = Nb;
  } else
    nb_pixels[hook(6, lid)] = 0;
  barrier(0x01);
  if (lid < 128)
    if (nb_pixels[hook(6, lid)] && nb_pixels[hook(6, lid + 128)]) {
      Weight = convert_float(nb_pixels[hook(6, lid + 128)]) / nb_pixels[hook(6, lid)];
      buffer[hook(5, lid)] = max(buffer[hook(5, lid)], buffer[hook(5, lid + 128)]);
      nb_pixels[hook(6, lid)] += nb_pixels[hook(6, lid + 128)];
    };
  barrier(0x01);
  if (lid < 64)
    if (nb_pixels[hook(6, lid)] && nb_pixels[hook(6, lid + 64)]) {
      Weight = convert_float(nb_pixels[hook(6, lid + 64)]) / nb_pixels[hook(6, lid)];
      buffer[hook(5, lid)] = max(buffer[hook(5, lid)], buffer[hook(5, lid + 64)]);
      nb_pixels[hook(6, lid)] += nb_pixels[hook(6, lid + 64)];
    };
  barrier(0x01);
  if (lid < 32)
    if (nb_pixels[hook(6, lid)] && nb_pixels[hook(6, lid + 32)]) {
      Weight = convert_float(nb_pixels[hook(6, lid + 32)]) / nb_pixels[hook(6, lid)];
      buffer[hook(5, lid)] = max(buffer[hook(5, lid)], buffer[hook(5, lid + 32)]);
      nb_pixels[hook(6, lid)] += nb_pixels[hook(6, lid + 32)];
    };
  barrier(0x01);
  if (lid < 16)
    if (nb_pixels[hook(6, lid)] && nb_pixels[hook(6, lid + 16)]) {
      Weight = convert_float(nb_pixels[hook(6, lid + 16)]) / nb_pixels[hook(6, lid)];
      buffer[hook(5, lid)] = max(buffer[hook(5, lid)], buffer[hook(5, lid + 16)]);
      nb_pixels[hook(6, lid)] += nb_pixels[hook(6, lid + 16)];
    };
  barrier(0x01);
  if (lid < 8)
    if (nb_pixels[hook(6, lid)] && nb_pixels[hook(6, lid + 8)]) {
      Weight = convert_float(nb_pixels[hook(6, lid + 8)]) / nb_pixels[hook(6, lid)];
      buffer[hook(5, lid)] = max(buffer[hook(5, lid)], buffer[hook(5, lid + 8)]);
      nb_pixels[hook(6, lid)] += nb_pixels[hook(6, lid + 8)];
    };
  barrier(0x01);
  if (lid < 4)
    if (nb_pixels[hook(6, lid)] && nb_pixels[hook(6, lid + 4)]) {
      Weight = convert_float(nb_pixels[hook(6, lid + 4)]) / nb_pixels[hook(6, lid)];
      buffer[hook(5, lid)] = max(buffer[hook(5, lid)], buffer[hook(5, lid + 4)]);
      nb_pixels[hook(6, lid)] += nb_pixels[hook(6, lid + 4)];
    };
  barrier(0x01);
  if (lid < 2)
    if (nb_pixels[hook(6, lid)] && nb_pixels[hook(6, lid + 2)]) {
      Weight = convert_float(nb_pixels[hook(6, lid + 2)]) / nb_pixels[hook(6, lid)];
      buffer[hook(5, lid)] = max(buffer[hook(5, lid)], buffer[hook(5, lid + 2)]);
      nb_pixels[hook(6, lid)] += nb_pixels[hook(6, lid + 2)];
    };
  barrier(0x01);
  if (lid == 0) {
    if (nb_pixels[hook(6, lid)] && nb_pixels[hook(6, lid + 1)]) {
      Weight = convert_float(nb_pixels[hook(6, lid + 1)]) / nb_pixels[hook(6, lid)];
      buffer[hook(5, lid)] = max(buffer[hook(5, lid)], buffer[hook(5, lid + 1)]);
      nb_pixels[hook(6, lid)] += nb_pixels[hook(6, lid + 1)];
    };
    atomic_maxf_1(result, buffer[hook(5, 0)], nb_pixels[hook(6, 0)]);
  }
}