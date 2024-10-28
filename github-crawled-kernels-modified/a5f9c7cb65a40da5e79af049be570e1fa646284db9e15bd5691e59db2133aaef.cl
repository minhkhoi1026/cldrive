//{"iObs":9,"maxInd":6,"maxProbNew":0,"maxProbOld":2,"maxValue":5,"mtEmit":4,"mtState":3,"nState":7,"obs":8,"path":1}
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
      m1 = maxValue[hook(5, localId)];
      m2 = maxValue[hook(5, localId + s)];
      m3 = (m1 >= m2) ? m1 : m2;
      idx = (m1 >= m2) ? localId : localId + s;
      maxValue[hook(5, localId)] = m3;
      maxInd[hook(6, localId)] = maxInd[hook(6, idx)];
    }
    barrier(0x01);
  }

  if (localId < 32) {
    m1 = maxValue[hook(5, localId)];
    m2 = maxValue[hook(5, localId + 32)];
    m3 = (m1 > m2) ? m1 : m2;
    idx = (m1 > m2) ? localId : localId + 32;
    maxValue[hook(5, localId)] = m3;
    maxInd[hook(6, localId)] = maxInd[hook(6, idx)];

    m1 = maxValue[hook(5, localId)];
    m2 = maxValue[hook(5, localId + 16)];
    m3 = (m1 > m2) ? m1 : m2;
    idx = (m1 > m2) ? localId : localId + 16;
    maxValue[hook(5, localId)] = m3;
    maxInd[hook(6, localId)] = maxInd[hook(6, idx)];

    m1 = maxValue[hook(5, localId)];
    m2 = maxValue[hook(5, localId + 8)];
    m3 = (m1 > m2) ? m1 : m2;
    idx = (m1 > m2) ? localId : localId + 8;
    maxValue[hook(5, localId)] = m3;
    maxInd[hook(6, localId)] = maxInd[hook(6, idx)];

    m1 = maxValue[hook(5, localId)];
    m2 = maxValue[hook(5, localId + 4)];
    m3 = (m1 > m2) ? m1 : m2;
    idx = (m1 > m2) ? localId : localId + 4;
    maxValue[hook(5, localId)] = m3;
    maxInd[hook(6, localId)] = maxInd[hook(6, idx)];

    m1 = maxValue[hook(5, localId)];
    m2 = maxValue[hook(5, localId + 2)];
    m3 = (m1 > m2) ? m1 : m2;
    idx = (m1 > m2) ? localId : localId + 2;
    maxValue[hook(5, localId)] = m3;
    maxInd[hook(6, localId)] = maxInd[hook(6, idx)];

    m1 = maxValue[hook(5, localId)];
    m2 = maxValue[hook(5, localId + 1)];
    m3 = (m1 > m2) ? m1 : m2;
    idx = (m1 > m2) ? localId : localId + 1;
    maxValue[hook(5, localId)] = m3;
    maxInd[hook(6, localId)] = maxInd[hook(6, idx)];
  }
}

kernel void ViterbiOneStep(global float* maxProbNew, global int* path, global float* maxProbOld, global float* mtState, global float* mtEmit, local float maxValue[], local int maxInd[], int nState, int obs, int iObs) {
  unsigned int groupId = get_group_id(0) + get_group_id(1) * get_num_groups(0);
  unsigned int localId = get_local_id(0);
  unsigned int localSize = get_local_size(0);

  unsigned int iState = groupId;

  float mValue = -1.0f;
  int mInd = -1;
  float value;
  for (int i = localId; i < nState; i += localSize) {
    value = maxProbOld[hook(2, i)] + mtState[hook(3, iState * nState + i)];
    if (value > mValue) {
      mValue = value;
      mInd = i;
    }
  }
  maxValue[hook(5, localId)] = mValue;
  maxInd[hook(6, localId)] = mInd;
  barrier(0x01);

  maxOneBlock(maxValue, maxInd);

  if (localId == 0) {
    maxProbNew[hook(0, iState)] = maxValue[hook(5, 0)] + mtEmit[hook(4, obs * nState + iState)];
    path[hook(1, (iObs - 1) * nState + iState)] = maxInd[hook(6, 0)];
  }
}