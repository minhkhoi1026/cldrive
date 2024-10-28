//{"batch":3,"channels":4,"num":5,"out_data":2,"x_data":0,"y_data":1}
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

kernel void elementwise_add(global const float* x_data, global const float* y_data, global float* out_data, const int batch, const int channels, const int num) {
  const int c = get_global_id(0);
  const int b = get_global_id(1);

  if ((c >= channels) || (b >= batch)) {
    return;
  }

  const int offset = (b * channels + c) * num;

  global const float* din_ptr = x_data + offset;
  const float diny_data = y_data[hook(1, c)];
  global float* dout_ptr = out_data + offset;

  for (int n = 0; n < num; ++n) {
    *dout_ptr = *din_ptr + diny_data;

    ++dout_ptr;
    ++din_ptr;
  }
}