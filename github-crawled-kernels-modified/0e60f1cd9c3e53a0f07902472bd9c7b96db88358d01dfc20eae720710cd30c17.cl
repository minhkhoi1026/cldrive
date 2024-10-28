//{"M":0,"N":1,"beta":3,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mat_add_vec2(const int M, const int N, global float* c, float beta) {
  const int col = get_global_id(0) * 2;
  const int row = get_global_id(1);

  float2 cc = vload2(0, (c + row * N + col));

  float2 res = (float2)beta * cc;
  vstore2(res, 0, c + row * N + col);
}