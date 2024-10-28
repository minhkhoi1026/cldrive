//{"d_Call":0,"d_Put":1,"d_S":2,"d_T":4,"d_X":3,"optNN":5,"out":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float CND(float d);
void BlackScholesBody(global float* call, global float* put, float S, float X, float T, float R, float V);
float CND(float d) {
  const float A1 = 0.31938153f;
  const float A2 = -0.356563782f;
  const float A3 = 1.781477937f;
  const float A4 = -1.821255978f;
  const float A5 = 1.330274429f;
  const float RSQRT2PI = 0.39894228040143267793994605993438f;

  float K = 1.0f / (1.0f + 0.2316419f * fabs(d));

  float cnd = RSQRT2PI * exp(-0.5f * d * d) * (K * (A1 + K * (A2 + K * (A3 + K * (A4 + K * A5)))));

  if (d > 0) {
    cnd = 1.0f - cnd;
  }

  return cnd;
}

void BlackScholesBody(global float* call, global float* put, float S, float X, float T, float R, float V) {
  float sqrtT = sqrt(T);
  float d1 = (log(S / X) + (R + 0.5f * V * V) * T) / (V * sqrtT);
  float d2 = d1 - V * sqrtT;
  float CNDD1 = CND(d1);
  float CNDD2 = CND(d2);

  float expRT = exp(-R * T);
  *call = (S * CNDD1 - X * expRT * CNDD2);
  *put = (X * expRT * (1.0f - CNDD2) - S * (1.0f - CNDD1));
}

kernel void BlackScholes(global float* d_Call, global float* d_Put, global float* d_S, global float* d_X, global float* d_T, global float* optNN, global float* out) {
  const float R = 0.02f;
  const float V = 0.3f;

  unsigned int optN = (unsigned int)*optNN;

  for (unsigned int opt = get_global_id(0); opt < optN; opt += get_global_size(0)) {
    BlackScholesBody(&d_Call[hook(0, opt)], &d_Put[hook(1, opt)], d_S[hook(2, opt)], d_X[hook(3, opt)], d_T[hook(4, opt)], R, V);
    out[hook(6, opt)] = d_Call[hook(0, opt)];
  }
}