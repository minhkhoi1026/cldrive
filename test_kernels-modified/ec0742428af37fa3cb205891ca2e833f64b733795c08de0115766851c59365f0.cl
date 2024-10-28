//{"forcePairs":2,"maxp":5,"numPairs":0,"pairsList":1,"test":4,"totalForce":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void force_total(global int* numPairs, global int* pairsList, global float4* forcePairs, global float4* totalForce, global float4* test, int maxp) {
  int i = get_global_id(0);
  float4 total = (float4)(0, 0, 0, 0);

  int np = numPairs[hook(0, i)];

  for (int n = 0; n < np; n++) {
    int s = +1;
    int j = pairsList[hook(1, maxp * i + n)];

    if (j < 0) {
      s = -1;
      j *= -1;
    }
    j -= 1;

    float4 f = forcePairs[hook(2, j)];
    total += f * (float)(s);
  }

  totalForce[hook(3, i)] += total;
}