//{"bn_biases":2,"bn_running_mean":3,"bn_running_var":4,"bn_weights":1,"eps":7,"in_data":0,"in_size":6,"out_data":5,"relu_type":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void batchnorm(global float* restrict in_data, global float* restrict bn_weights, global float* restrict bn_biases, global float* restrict bn_running_mean, global float* restrict bn_running_var, global float* restrict out_data, const int in_size, const float eps, const int relu_type) {
  int filter_index = get_global_id(0);
  int pixel_index = get_global_id(1);
  int index = filter_index * in_size + pixel_index;
  float out;

  out = (bn_weights[hook(1, filter_index)] * ((in_data[hook(0, index)] - bn_running_mean[hook(3, filter_index)]) / sqrt(bn_running_var[hook(4, filter_index)] + eps))) + bn_biases[hook(2, filter_index)];

  if (relu_type == 1)
    out_data[hook(5, index)] = (out > 0.0f) ? out : (out * 0.1f);
  else
    out_data[hook(5, index)] = out;
}