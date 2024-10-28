//{"adjOffsets":3,"adjPerVertex":2,"adjVerts":4,"inPts":1,"numElements":5,"outPts":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void smooth(global float* outPts, global const float* inPts, global const int* adjPerVertex, global const int* adjOffsets, global const int* adjVerts, const int numElements) {
  unsigned int positionId = get_global_id(0);

  if (positionId >= numElements) {
    return;
  }
  unsigned int offset = positionId * 3;

  float avgx = 0.0;
  float avgy = 0.0;
  float avgz = 0.0;

  float ptx = inPts[hook(1, offset)];
  float pty = inPts[hook(1, offset + 1)];
  float ptz = inPts[hook(1, offset + 2)];

  int adjOff = adjOffsets[hook(3, positionId)];
  int adjPer = adjPerVertex[hook(2, positionId)];
  float adjInv = 1 / (float)adjPer;

  for (unsigned int i = 0; i < adjPer; ++i) {
    int adjId = adjVerts[hook(4, adjOff + i)];
    float adjx = inPts[hook(1, adjId * 3)];
    float adjy = inPts[hook(1, adjId * 3 + 1)];
    float adjz = inPts[hook(1, adjId * 3 + 2)];

    avgx += adjx;
    avgy += adjy;
    avgz += adjz;
  }

  avgx *= adjInv;
  avgy *= adjInv;
  avgz *= adjInv;

  outPts[hook(0, offset)] = avgx;
  outPts[hook(0, offset + 1)] = avgy;
  outPts[hook(0, offset + 2)] = avgz;
}