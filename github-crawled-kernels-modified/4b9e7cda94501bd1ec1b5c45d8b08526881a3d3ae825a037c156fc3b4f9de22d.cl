//{"elementsNumber":3,"pInputVector1":0,"pInputVector2":1,"pOutputVectorHost":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float MathCalculations(float a, float b) {
  float res = 0;
  res += a * a * 0.315f + b * 0.512f + 0.789f;
  res += a * a * 0.15f + b * 0.12f + 0.789f;
  res += a * a * 0.35f + b * 0.51f + 0.89f;
  res += a * a * 0.31f + b * 0.52f + 0.7f;
  res += a * a * 0.4315f + b * 0.512f + 0.4789f;
  res += a * a * 0.515f + b * 0.132f + 0.7859f;
  res += a * a * 0.635f + b * 0.521f + 0.89f;
  res += a * a * 0.731f + b * 0.152f + 0.7f;
  res += a * a * 0.1315f + b * 0.512f + 0.789f;
  res += a * a * 0.115f + b * 0.12f + 0.789f;
  res += a * a * 0.135f + b * 0.51f + 0.89f;
  res += a * a * 0.131f + b * 0.52f + 0.7f;
  res += a * a * 0.14315f + b * 0.512f + 0.4789f;
  res += a * a * 0.1515f + b * 0.132f + 0.7859f;
  res += a * a * 0.1635f + b * 0.521f + 0.89f;
  res += a * a * 0.1731f + b * 0.152f + 0.7f;
  res += a * a * 0.315f + b * 0.512f + 0.789f;
  res += a * a * 0.15f + b * 0.12f + 0.789f;
  res += a * a * 0.35f + b * 0.51f + 0.89f;
  res += a * a * 0.31f + b * 0.52f + 0.7f;
  res += a * a * 0.4315f + b * 0.512f + 0.4789f;
  res += a * a * 0.515f + b * 0.132f + 0.7859f;
  res += a * a * 0.635f + b * 0.521f + 0.89f;
  res += a * a * 0.731f + b * 0.152f + 0.7f;
  res += a * a * 0.1315f + b * 0.512f + 0.789f;
  res += a * a * 0.115f + b * 0.12f + 0.789f;
  res += a * a * 0.135f + b * 0.51f + 0.89f;
  res += a * a * 0.131f + b * 0.52f + 0.7f;
  res += a * a * 0.14315f + b * 0.512f + 0.4789f;
  res += a * a * 0.1515f + b * 0.132f + 0.7859f;
  res += a * a * 0.1635f + b * 0.521f + 0.89f;
  res += a * a * 0.1731f + b * 0.152f + 0.7f;
  res += a * a * 0.315f + b * 0.512f + 0.789f;
  res += a * a * 0.15f + b * 0.12f + 0.789f;
  res += a * a * 0.35f + b * 0.51f + 0.89f;
  res += a * a * 0.31f + b * 0.52f + 0.7f;
  res += a * a * 0.4315f + b * 0.512f + 0.4789f;
  res += a * a * 0.515f + b * 0.132f + 0.7859f;
  res += a * a * 0.635f + b * 0.521f + 0.89f;
  res += a * a * 0.731f + b * 0.152f + 0.7f;
  res += a * a * 0.1315f + b * 0.512f + 0.789f;
  res += a * a * 0.115f + b * 0.12f + 0.789f;
  res += a * a * 0.135f + b * 0.51f + 0.89f;
  res += a * a * 0.131f + b * 0.52f + 0.7f;
  res += a * a * 0.14315f + b * 0.512f + 0.4789f;
  res += a * a * 0.1515f + b * 0.132f + 0.7859f;
  res += a * a * 0.1635f + b * 0.521f + 0.89f;
  res += a * a * 0.1731f + b * 0.152f + 0.7f;
  res += a * a * 0.315f + b * 0.512f + 0.789f;
  res += a * a * 0.15f + b * 0.12f + 0.789f;
  res += a * a * 0.35f + b * 0.51f + 0.89f;
  res += a * a * 0.31f + b * 0.52f + 0.7f;
  res += a * a * 0.4315f + b * 0.512f + 0.4789f;
  res += a * a * 0.515f + b * 0.132f + 0.7859f;
  res += a * a * 0.635f + b * 0.521f + 0.89f;
  res += a * a * 0.731f + b * 0.152f + 0.7f;
  res += a * a * 0.1315f + b * 0.512f + 0.789f;
  res += a * a * 0.115f + b * 0.12f + 0.789f;
  res += a * a * 0.135f + b * 0.51f + 0.89f;
  res += a * a * 0.131f + b * 0.52f + 0.7f;
  res += a * a * 0.14315f + b * 0.512f + 0.4789f;
  res += a * a * 0.1515f + b * 0.132f + 0.7859f;
  res += a * a * 0.1635f + b * 0.521f + 0.89f;
  res += a * a * 0.1731f + b * 0.152f + 0.7f;
  res += a * a * 0.315f + b * 0.512f + 0.789f;
  res += a * a * 0.15f + b * 0.12f + 0.789f;
  res += a * a * 0.35f + b * 0.51f + 0.89f;
  res += a * a * 0.31f + b * 0.52f + 0.7f;
  res += a * a * 0.4315f + b * 0.512f + 0.4789f;
  res += a * a * 0.515f + b * 0.132f + 0.7859f;
  res += a * a * 0.635f + b * 0.521f + 0.89f;
  res += a * a * 0.731f + b * 0.152f + 0.7f;
  res += a * a * 0.1315f + b * 0.512f + 0.789f;
  res += a * a * 0.115f + b * 0.12f + 0.789f;
  res += a * a * 0.135f + b * 0.51f + 0.89f;
  res += a * a * 0.131f + b * 0.52f + 0.7f;
  res += a * a * 0.14315f + b * 0.512f + 0.4789f;
  res += a * a * 0.1515f + b * 0.132f + 0.7859f;
  res += a * a * 0.1635f + b * 0.521f + 0.89f;
  res += a * a * 0.1731f + b * 0.152f + 0.7f;
  res += a * a * 0.315f + b * 0.512f + 0.789f;
  res += a * a * 0.15f + b * 0.12f + 0.789f;
  res += a * a * 0.35f + b * 0.51f + 0.89f;
  res += a * a * 0.31f + b * 0.52f + 0.7f;
  res += a * a * 0.4315f + b * 0.512f + 0.4789f;
  res += a * a * 0.515f + b * 0.132f + 0.7859f;
  res += a * a * 0.635f + b * 0.521f + 0.89f;
  res += a * a * 0.731f + b * 0.152f + 0.7f;
  res += a * a * 0.1315f + b * 0.512f + 0.789f;
  res += a * a * 0.115f + b * 0.12f + 0.789f;
  res += a * a * 0.135f + b * 0.51f + 0.89f;
  res += a * a * 0.131f + b * 0.52f + 0.7f;
  res += a * a * 0.14315f + b * 0.512f + 0.4789f;
  res += a * a * 0.1515f + b * 0.132f + 0.7859f;
  res += a * a * 0.1635f + b * 0.521f + 0.89f;
  res += a * a * 0.1731f + b * 0.152f + 0.7f;
  return res;
}

kernel void TestKernel(global const float* pInputVector1, global const float* pInputVector2, global float* pOutputVectorHost, int elementsNumber) {
  int iJob = get_global_id(0);

  if (iJob >= elementsNumber)
    return;

  pOutputVectorHost[hook(2, iJob)] = MathCalculations(pInputVector1[hook(0, iJob)], pInputVector2[hook(1, iJob)]);
}