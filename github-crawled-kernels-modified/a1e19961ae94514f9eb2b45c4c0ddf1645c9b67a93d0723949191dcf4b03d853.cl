//{"coefx":2,"coefy":3,"coefz":4,"dimx":5,"dimy":6,"dimz":7,"input":0,"output":1,"sx":8,"sy":9,"sz":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void stencil_v_3d(global float4* input, global float4* output, constant float* coefx, constant float* coefy, constant float* coefz, int dimx, int dimy, int dimz, int sx, int sy, int sz) {
  int xgid = get_global_id(0);
  int ygid = get_global_id(1);
  int zgid;
  float4 v, l, r;
  dimx = dimx >> 2;

  float4 f0, f1, f2, f3;
  float4 b0, b1, b2, b3;
  float4 current;
  float coef0 = coefx[hook(2, 0)] + coefy[hook(3, 0)] + coefz[hook(4, 0)];

  if ((xgid < dimx) && (ygid < dimy)) {
    b3 = 0.;
    b2 = input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (-4 + sz) + ygid + sy) + xgid + 1)];
    b1 = input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (-3 + sz) + ygid + sy) + xgid + 1)];
    b0 = input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (-2 + sz) + ygid + sy) + xgid + 1)];
    current = input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (-1 + sz) + ygid + sy) + xgid + 1)];
    f0 = input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (0 + sz) + ygid + sy) + xgid + 1)];
    f1 = input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (1 + sz) + ygid + sy) + xgid + 1)];
    f2 = input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (2 + sz) + ygid + sy) + xgid + 1)];
    f3 = input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (3 + sz) + ygid + sy) + xgid + 1)];

    for (zgid = 0; zgid < dimz; ++zgid) {
      b3 = b2;
      b2 = b1;
      b1 = b0;
      b0 = current;
      current = f0;
      f0 = f1;
      f1 = f2;
      f2 = f3;
      f3 = input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (zgid + sz + sz) + ygid + sy) + xgid + 1)];

      r = input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (zgid + sz) + ygid + sy) + xgid + 1 + 1)];
      l = input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (zgid + sz) + ygid + sy) + xgid - 1 + 1)];

      v = coef0 * current;
      v += coefx[hook(2, 1)] * ((float4)(current.yzw, r.x) + (float4)(l.w, current.xyz));
      v += coefx[hook(2, 2)] * ((float4)(current.zw, r.xy) + (float4)(l.zw, current.xy));
      v += coefx[hook(2, 3)] * ((float4)(current.w, r.xyz) + (float4)(l.yzw, current.x));
      v += coefx[hook(2, 4)] * (r + l);

      v += coefy[hook(3, 1)] * (input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (zgid + sz) + ygid + 1 + sy) + xgid + 1)] + input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (zgid + sz) + ygid - 1 + sy) + xgid + 1)]);
      v += coefy[hook(3, 2)] * (input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (zgid + sz) + ygid + 2 + sy) + xgid + 1)] + input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (zgid + sz) + ygid - 2 + sy) + xgid + 1)]);
      v += coefy[hook(3, 3)] * (input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (zgid + sz) + ygid + 3 + sy) + xgid + 1)] + input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (zgid + sz) + ygid - 3 + sy) + xgid + 1)]);
      v += coefy[hook(3, 4)] * (input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (zgid + sz) + ygid + 4 + sy) + xgid + 1)] + input[hook(0, (2 + dimx) * ((2 * sy + dimy) * (zgid + sz) + ygid - 4 + sy) + xgid + 1)]);

      v += coefz[hook(4, 1)] * (f0 + b0);
      v += coefz[hook(4, 2)] * (f1 + b1);
      v += coefz[hook(4, 3)] * (f2 + b2);
      v += coefz[hook(4, 4)] * (f3 + b3);

      output[hook(1, (2 + dimx) * ((2 * sy + dimy) * (zgid + sz) + ygid + sy) + xgid + 1)] = current + v;
    }
  }
}