//{"data":0,"data_err":1,"model":2,"n":5,"output":3,"start":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void chi(global float* data, global float* data_err, global float* model, global float* output, private unsigned int start, private unsigned int n) {
  size_t i = get_global_id(0);
  size_t index = start + i;

  float temp = 0;

  if (i < n)
    temp = (data[hook(0, index)] - model[hook(2, index)]) / data_err[hook(1, index)];

  output[hook(3, index)] = temp;
}