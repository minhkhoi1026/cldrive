//{"coeffs":0,"input":2,"order":1,"result":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void PolyEvalOcl(global float* coeffs, unsigned int order, global float* input, global float* result) {
  const unsigned int id = get_global_id(0);
  float val = input[hook(2, id)];
  float out = 0;
  for (unsigned int i = 0; i <= order; ++i)
    out += coeffs[hook(0, i)] * pow(val, i);

  result[hook(3, id)] = out;
}