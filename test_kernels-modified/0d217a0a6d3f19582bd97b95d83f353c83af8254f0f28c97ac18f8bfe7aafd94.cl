//{"ft_input":0,"n_t3":4,"offset":3,"output":5,"uv_ref":1,"uv_sign":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 MultComplex2(float2 A, float2 B);
float2 MultComplex3(float2 A, float2 B, float2 C);
float2 MultComplex2(float2 A, float2 B) {
  float2 temp;

  temp.s0 = A.s0 * B.s0 - A.s1 * B.s1;

  temp.s1 = A.s1 * B.s0 + A.s0 * B.s1;

  return temp;
}

float2 MultComplex3(float2 A, float2 B, float2 C) {
  A = MultComplex2(A, B);
  return MultComplex2(A, C);
}

kernel void ft_to_t3(global float2* ft_input, global uint4* uv_ref, global short4* uv_sign, private unsigned int offset, private unsigned int n_t3, global float* output) {
  size_t i = get_global_id(0);

  uint4 uvpnt = uv_ref[hook(1, i)];
  float2 vab = ft_input[hook(0, uvpnt.s0)];
  float2 vbc = ft_input[hook(0, uvpnt.s1)];
  float2 vca = ft_input[hook(0, uvpnt.s2)];

  short4 sign = uv_sign[hook(2, i)];
  vab.s1 *= sign.s0;
  vbc.s1 *= sign.s1;
  vca.s1 *= sign.s2;

  vca.s1 *= -1;

  float2 temp = MultComplex3(vab, vbc, vca);

  if (i < n_t3) {
    output[hook(5, offset + i)] = temp.s0;
    output[hook(5, offset + n_t3 + i)] = temp.s1;
  }
}