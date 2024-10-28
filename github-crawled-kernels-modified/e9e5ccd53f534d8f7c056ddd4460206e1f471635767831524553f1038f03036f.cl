//{"maxInd":7,"maxProbNew":2,"maxValue":6,"nObs":5,"nState":4,"path":3,"vPath":1,"vProb":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void maxOneBlock(local float maxValue[], local int maxInd[]) {
  unsigned int localId = get_local_id(0);
  unsigned int localSize = get_local_size(0);
  int idx;
  float m1, m2, m3;

  for (unsigned int s = localSize / 2; s > 32; s >>= 1) {
    if (localId < s) {
      m1 = maxValue[hook(6, localId)];
      m2 = maxValue[hook(6, localId + s)];
      m3 = (m1 >= m2) ? m1 : m2;
      idx = (m1 >= m2) ? localId : localId + s;
      maxValue[hook(6, localId)] = m3;
      maxInd[hook(7, localId)] = maxInd[hook(7, idx)];
    }
    barrier(0x01);
  }

  if (localId < 32) {
    m1 = maxValue[hook(6, localId)];
    m2 = maxValue[hook(6, localId + 32)];
    m3 = (m1 > m2) ? m1 : m2;
    idx = (m1 > m2) ? localId : localId + 32;
    maxValue[hook(6, localId)] = m3;
    maxInd[hook(7, localId)] = maxInd[hook(7, idx)];

    m1 = maxValue[hook(6, localId)];
    m2 = maxValue[hook(6, localId + 16)];
    m3 = (m1 > m2) ? m1 : m2;
    idx = (m1 > m2) ? localId : localId + 16;
    maxValue[hook(6, localId)] = m3;
    maxInd[hook(7, localId)] = maxInd[hook(7, idx)];

    m1 = maxValue[hook(6, localId)];
    m2 = maxValue[hook(6, localId + 8)];
    m3 = (m1 > m2) ? m1 : m2;
    idx = (m1 > m2) ? localId : localId + 8;
    maxValue[hook(6, localId)] = m3;
    maxInd[hook(7, localId)] = maxInd[hook(7, idx)];

    m1 = maxValue[hook(6, localId)];
    m2 = maxValue[hook(6, localId + 4)];
    m3 = (m1 > m2) ? m1 : m2;
    idx = (m1 > m2) ? localId : localId + 4;
    maxValue[hook(6, localId)] = m3;
    maxInd[hook(7, localId)] = maxInd[hook(7, idx)];

    m1 = maxValue[hook(6, localId)];
    m2 = maxValue[hook(6, localId + 2)];
    m3 = (m1 > m2) ? m1 : m2;
    idx = (m1 > m2) ? localId : localId + 2;
    maxValue[hook(6, localId)] = m3;
    maxInd[hook(7, localId)] = maxInd[hook(7, idx)];

    m1 = maxValue[hook(6, localId)];
    m2 = maxValue[hook(6, localId + 1)];
    m3 = (m1 > m2) ? m1 : m2;
    idx = (m1 > m2) ? localId : localId + 1;
    maxValue[hook(6, localId)] = m3;
    maxInd[hook(7, localId)] = maxInd[hook(7, idx)];
  }
}

kernel void ViterbiPath(global float* vProb, global int* vPath, global float* maxProbNew, global int* path, int nState, int nObs) {
  if (get_global_id(0) == 0) {
    float maxProb = 0.0;
    int maxState = -1;
    for (int i = 0; i < nState; i++) {
      if (maxProbNew[hook(2, i)] > maxProb) {
        maxProb = maxProbNew[hook(2, i)];
        maxState = i;
      }
    }
    *vProb = maxProb;

    vPath[hook(1, nObs - 1)] = maxState;
    mem_fence(0x02);
    for (int t = nObs - 2; t >= 0; t--) {
      vPath[hook(1, t)] = path[hook(3, t * nState + vPath[thook(1, t + 1))];
      mem_fence(0x02);
    }
  }
}