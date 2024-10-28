//{"d_Output":0,"iDevice":2,"nDevice":3,"pathN":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float MoroInvCNDgpu(unsigned int x) {
  const float a1 = 2.50662823884f;
  const float a2 = -18.61500062529f;
  const float a3 = 41.39119773534f;
  const float a4 = -25.44106049637f;
  const float b1 = -8.4735109309f;
  const float b2 = 23.08336743743f;
  const float b3 = -21.06224101826f;
  const float b4 = 3.13082909833f;
  const float c1 = 0.337475482272615f;
  const float c2 = 0.976169019091719f;
  const float c3 = 0.160797971491821f;
  const float c4 = 2.76438810333863E-02f;
  const float c5 = 3.8405729373609E-03f;
  const float c6 = 3.951896511919E-04f;
  const float c7 = 3.21767881768E-05f;
  const float c8 = 2.888167364E-07f;
  const float c9 = 3.960315187E-07f;

  float z;

  bool negate = false;

  if (x >= 0x80000000UL) {
    x = 0xffffffffUL - x;
    negate = true;
  }

  const float x1 = 1.0f / (float)0xffffffffUL;
  const float x2 = x1 / 2.0f;
  float p1 = x * x1 + x2;

  float p2 = p1 - 0.5f;

  if (p2 > -0.42f) {
    z = p2 * p2;
    z = p2 * (((a4 * z + a3) * z + a2) * z + a1) / ((((b4 * z + b3) * z + b2) * z + b1) * z + 1.0f);
  }

  else {
    z = log(-log(p1));
    z = -(c1 + z * (c2 + z * (c3 + z * (c4 + z * (c5 + z * (c6 + z * (c7 + z * (c8 + z * c9))))))));
  }

  return negate ? -z : z;
}

kernel void InverseCND(global float* d_Output, const unsigned int pathN, const unsigned int iDevice, const unsigned int nDevice) {
  const unsigned int distance = ((unsigned int)-1) / (pathN * nDevice + 1);
  const unsigned int globalID = get_global_id(0);
  const unsigned int globalSize = get_global_size(0);

  for (unsigned int pos = globalID; pos < pathN; pos += globalSize) {
    unsigned int d = (iDevice * pathN + pos + 1) * distance;
    d_Output[hook(0, pos)] = MoroInvCNDgpu(d);
  }
}