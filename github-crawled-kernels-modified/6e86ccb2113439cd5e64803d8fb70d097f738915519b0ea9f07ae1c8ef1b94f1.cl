//{"data":0,"data_err":1,"model":2,"n":5,"output":3,"start":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 MultComplex2(float2 A, float2 B);
float cabs(float2 A);
float carg(float2 A);
float2 MultComplex2(float2 A, float2 B) {
  float2 temp;

  temp.s0 = A.s0 * B.s0 - A.s1 * B.s1;

  temp.s1 = A.s1 * B.s0 + A.s0 * B.s1;

  return temp;
}

float cabs(float2 A) {
  return sqrt(A.s0 * A.s0 + A.s1 * A.s1);
}

float carg(float2 A) {
  return atan2(A.s1, A.s0);
}

kernel void chi_complex_convex(global float* data, global float* data_err, global float* model, global float* output, private unsigned int start, private unsigned int n) {
  size_t i = get_global_id(0);
  size_t index = start + i;

  float2 tmp_data;
  tmp_data.s0 = data[hook(0, index)];
  tmp_data.s1 = data[hook(0, n + index)];

  float2 tmp_data_err;
  tmp_data_err.s0 = data_err[hook(1, index)];
  tmp_data_err.s1 = tmp_data.s0 * data_err[hook(1, n + index)];

  float2 tmp_model;
  tmp_model.s0 = model[hook(2, index)];
  tmp_model.s1 = model[hook(2, n + index)];

  float2 phasor;
  phasor.s0 = cos(tmp_data.s1);
  phasor.s1 = -sin(tmp_data.s1);

  tmp_data = MultComplex2(tmp_data, phasor);
  tmp_model = MultComplex2(tmp_model, phasor);

  if (i < n) {
    output[hook(3, index)] = (cabs(tmp_data) - cabs(tmp_model)) / tmp_data_err.s0;
    output[hook(3, n + index)] = (carg(tmp_data) - carg(tmp_model)) / (cabs(tmp_data) * tmp_data_err.s1);
  }
}