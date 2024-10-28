//{"buffer":2,"result":1,"source":0}
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
  buffer[hook(2, offset * 4 + gid)] = nb_pixels;
}
__attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) kernel void init(global const uchar* source, global float* result) {
  *result = convert_float(*source);
}