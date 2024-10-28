//{"buffer":5,"img_height":4,"img_width":3,"result":1,"source":0,"src_step":2}
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
__attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) kernel void reduce_mean_sqr_flush(global const uchar* source, global float* result, int src_step, int img_width, int img_height) {
  local float buffer[(16 * 16)];
  int gx1 = get_global_id(0);
  const int gx = (gx1 & (16 - 1)) + (gx1 >> 4) * 16 * 16;
  const int gy = get_global_id(1);
  const int lid = get_local_id(1) * get_local_size(0) + get_local_id(0);
  src_step /= sizeof(uchar);
  float Res = convert_float(source[hook(0, (gy * src_step) + gx + 0)]);
  Res = (Res * Res);
  for (int i = 16; i < 16 * 16; i += 16) {
    float px = convert_float(source[hook(0, (gy * src_step) + gx + i)]);
    Res = (Res + (px * px));
  }
  buffer[hook(5, lid)] = (Res / 16);
  barrier(0x01);
  if (lid < 128)
    buffer[hook(5, lid)] = ((buffer[hook(5, lid)] + buffer[hook(5, lid + 128)] * 1) / (1 + 1));
  barrier(0x01);
  if (lid < 64)
    buffer[hook(5, lid)] = ((buffer[hook(5, lid)] + buffer[hook(5, lid + 64)] * 1) / (1 + 1));
  barrier(0x01);
  if (lid < 32)
    buffer[hook(5, lid)] = ((buffer[hook(5, lid)] + buffer[hook(5, lid + 32)] * 1) / (1 + 1));
  barrier(0x01);
  if (lid < 16)
    buffer[hook(5, lid)] = ((buffer[hook(5, lid)] + buffer[hook(5, lid + 16)] * 1) / (1 + 1));
  barrier(0x01);
  if (lid < 8)
    buffer[hook(5, lid)] = ((buffer[hook(5, lid)] + buffer[hook(5, lid + 8)] * 1) / (1 + 1));
  barrier(0x01);
  if (lid < 4)
    buffer[hook(5, lid)] = ((buffer[hook(5, lid)] + buffer[hook(5, lid + 4)] * 1) / (1 + 1));
  barrier(0x01);
  if (lid < 2)
    buffer[hook(5, lid)] = ((buffer[hook(5, lid)] + buffer[hook(5, lid + 2)] * 1) / (1 + 1));
  barrier(0x01);
  if (lid == 0) {
    buffer[hook(5, lid)] = ((buffer[hook(5, lid)] + buffer[hook(5, lid + 1)] * 1) / (1 + 1));
    store_value(result, buffer[hook(5, 0)], 16 * 16 * 16);
  }
}