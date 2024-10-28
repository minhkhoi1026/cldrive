//{"inputoffsetA":3,"inputoffsetB":4,"inputstrideA":5,"inputstrideB":6,"outputstride":7,"pInputA":8,"pInputAFlt":0,"pInputB":9,"pInputBFlt":1,"pResult":10,"pResultFlt":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void VectorComplexMulAccum(global float* pInputAFlt, global float* pInputBFlt, global float* pResultFlt, int inputoffsetA, int inputoffsetB, int inputstrideA, int inputstrideB, int outputstride) {
  int x = get_global_id(0);
  int chan = get_global_id(1);

  global float4* pInputA = (global float4*)(pInputAFlt + chan * inputstrideA + inputoffsetA);
  global float4* pInputB = (global float4*)(pInputBFlt + chan * inputstrideB + inputoffsetB);
  global float4* pResult = (global float4*)(pResultFlt + chan * outputstride);

  float4 inA = pInputA[hook(8, x)];
  float4 inB = pInputB[hook(9, x)];

  pResult[hook(10, x)].xz = pResult[hook(10, x)].xz + inA.xz * inB.xz - inA.yw * inB.yw;
  pResult[hook(10, x)].yw = pResult[hook(10, x)].xz + inA.xz * inB.yw + inA.yw * inB.xz;
}