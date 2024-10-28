//{"count":1,"out_data":2,"x_data":0}
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

kernel void relu(global const float* x_data, const int count, global float* out_data) {
  const int index = get_global_id(0);
  if (index < count) {
    out_data[hook(2, index)] = activation(x_data[hook(0, index)]);
  }
}