//{"axis_size":4,"out_data":2,"post_size":6,"pre_size":5,"size":3,"total":7,"total0":8,"total1":9,"x_data0":0,"x_data1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float activation(float in) {
  float output = in;
  return output;
}

inline float4 activation_type4(float4 in

) {
  float4 output = in;
  return output;
}

kernel void concat2(global const float* x_data0, global const float* x_data1, global float* out_data, int size, int axis_size, int pre_size, int post_size, int total, int total0, int total1) {
  const int index = get_global_id(0);
  if (index < size) {
    for (int i = 0; i < pre_size; i++) {
      int offset_out = index * post_size + i * total;
      int offset_in = index * post_size + i * total0;

      global float* dst = (global float*)(out_data + offset_out);
      global float* src = (global float*)(x_data0 + offset_in);
      for (int k = 0; k < post_size; k++) {
        *dst++ = *src++;
      }
    }
  } else if (index < axis_size) {
    for (int i = 0; i < pre_size; i++) {
      int offset_out = index * post_size + i * total;
      int offset_in = index * post_size + i * total1;

      global float* dst = (global float*)(out_data + offset_out);
      global float* src = (global float*)(x_data1 + offset_in);
      for (int k = 0; k < post_size; k++) {
        *dst++ = *src++;
      }
    }
  }
}