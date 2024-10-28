//{"A":8,"Atimesp":4,"b":9,"cols":7,"dim":0,"nVals":1,"p":5,"r":2,"result":10,"rows":6,"x":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conjGrad(int dim, int nVals, local float* r, local float* x, local float* Atimesp, local float* p, constant int* rows, constant int* cols, constant float* A, constant float* b, global float* result) {
  int id = get_local_id(0);

  int startIdx = -1;
  int endIdx = -1;

  for (int i = id; i < nVals; ++i) {
    if (rows[hook(6, i)] == id && startIdx == -1)
      startIdx = i;
    else if (rows[hook(6, i)] == id + 1 && endIdx == -1) {
      endIdx = i - 1;
      break;
    } else if (i == nVals - 1 && endIdx == -1)
      endIdx = i;
  }

  x[hook(3, id)] = 0.0f;
  r[hook(2, id)] = b[hook(9, id)];
  p[hook(5, id)] = b[hook(9, id)];

  barrier(0x01);

  local float oldRdotR, rLen;
  if (id == 0) {
    oldRdotR = 0.0f;
    for (int i = 0; i < dim; ++i)
      oldRdotR += r[hook(2, i)] * r[hook(2, i)];

    rLen = sqrt(oldRdotR);
  }
  barrier(0x01);

  local float alpha, newRdotR, ApDotp;
  local int iteration;
  iteration = 0;
  while (iteration < 1000 && rLen >= 0.01f) {
    Atimesp[hook(4, id)] = 0.0f;
    for (int i = startIdx; i <= endIdx; ++i)
      Atimesp[hook(4, id)] += A[hook(8, i)] * p[hook(5, cols[ihook(7, i))];

    barrier(0x01);

    if (id == 0) {
      ApDotp = 0.0f;
      for (int i = 0; i < dim; ++i)
        ApDotp += Atimesp[hook(4, i)] * p[hook(5, i)];

      alpha = oldRdotR / ApDotp;
    }
    barrier(0x01);

    x[hook(3, id)] += alpha * p[hook(5, id)];
    r[hook(2, id)] -= alpha * Atimesp[hook(4, id)];
    barrier(0x01);

    if (id == 0) {
      newRdotR = 0.0f;
      for (int i = 0; i < dim; ++i)
        newRdotR += r[hook(2, i)] * r[hook(2, i)];

      rLen = sqrt(newRdotR);
    }
    barrier(0x01);

    p[hook(5, id)] = r[hook(2, id)] + (newRdotR / oldRdotR) * p[hook(5, id)];
    barrier(0x01);

    oldRdotR = newRdotR;

    if (id == 0)
      ++iteration;

    barrier(0x01);
  }
  result[hook(10, 0)] = iteration * 1.0f;
  result[hook(10, 1)] = rLen;

  result[hook(10, id + 2)] = x[hook(3, id)];
}