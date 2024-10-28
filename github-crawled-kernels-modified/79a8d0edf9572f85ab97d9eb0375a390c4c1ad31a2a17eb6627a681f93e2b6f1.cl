//{"b":1,"bSpeed":3,"nInput":4,"nOutput":5,"w":0,"wSpeed":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FCUpdateParameters(global float* w, global float* b, global float* wSpeed, global float* bSpeed, const int nInput, const int nOutput) {
  const int i = get_global_id(0);
  const int j = get_global_id(1);

  if (i < nOutput && j < nInput) {
    int iWeight = i * nInput + j;
    w[hook(0, iWeight)] += wSpeed[hook(2, iWeight)];

    if (j == 0) {
      b[hook(1, i)] += bSpeed[hook(3, i)];
    }
  }
}