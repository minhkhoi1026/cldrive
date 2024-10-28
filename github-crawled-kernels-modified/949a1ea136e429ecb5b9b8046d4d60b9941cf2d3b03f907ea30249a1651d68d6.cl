//{"input1":0,"input2":1,"output":2,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fft_mult_vec(global const float2* input1, global const float2* input2, global float2* output, unsigned int size) {
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    float2 in1 = input1[hook(0, i)];
    float2 in2 = input2[hook(1, i)];

    output[hook(2, i)] = (float2)(in1.x * in2.x - in1.y * in2.y, in1.x * in2.y + in1.y * in2.x);
  }
}