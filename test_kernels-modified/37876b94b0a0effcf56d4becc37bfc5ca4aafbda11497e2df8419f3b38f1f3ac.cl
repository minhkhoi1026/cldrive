//{"adjOffsets":4,"adjPerVertex":3,"adjVerts":5,"currentPts":1,"deltas":6,"envelope":8,"finalPts":0,"numElements":9,"smoothPts":2,"weights":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void delta(global float* finalPts, global const float* currentPts, global const float* smoothPts, global const int* adjPerVertex, global const int* adjOffsets, global const int* adjVerts, global const float* deltas, global const float* weights, const float envelope, const int numElements) {
  unsigned int positionId = get_global_id(0);
  if (positionId >= numElements) {
    return;
  }
  unsigned int posOffset = positionId * 3;

  float ptx = currentPts[hook(1, posOffset)];
  float pty = currentPts[hook(1, posOffset + 1)];
  float ptz = currentPts[hook(1, posOffset + 2)];

  float smx = smoothPts[hook(2, posOffset)];
  float smy = smoothPts[hook(2, posOffset + 1)];
  float smz = smoothPts[hook(2, posOffset + 2)];

  float dx = deltas[hook(6, posOffset)];
  float dy = deltas[hook(6, posOffset + 1)];
  float dz = deltas[hook(6, posOffset + 2)];

  int adjOff = adjOffsets[hook(4, positionId)];
  int adjIdX = adjVerts[hook(5, adjOff)];
  int adjIdZ = adjVerts[hook(5, adjOff + 1)];

  float adjxx = smoothPts[hook(2, adjIdX * 3)];
  float adjxy = smoothPts[hook(2, adjIdX * 3 + 1)];
  float adjxz = smoothPts[hook(2, adjIdX * 3 + 2)];

  float adjzx = smoothPts[hook(2, adjIdZ * 3)];
  float adjzy = smoothPts[hook(2, adjIdZ * 3 + 1)];
  float adjzz = smoothPts[hook(2, adjIdZ * 3 + 2)];

  float vxx = adjxx - smx;
  float vxy = adjxy - smy;
  float vxz = adjxz - smz;

  float vzx = adjzx - smx;
  float vzy = adjzy - smy;
  float vzz = adjzz - smz;

  float magx = 1 / sqrt(vxx * vxx + vxy * vxy + vxz * vxz);
  float magz = 1 / sqrt(vzx * vzx + vzy * vzy + vzz * vzz);

  vxx *= magx;
  vxy *= magx;
  vxz *= magx;

  vzx *= magz;
  vzy *= magz;
  vzz *= magz;

  float3 vx = (float3)(vxx, vxy, vxz);
  float3 vz = (float3)(vzx, vzy, vzz);

  float3 vy = cross(vx, vz);
  vy = normalize(vy);
  vz = cross(vx, vy);
  vz = normalize(vz);

  vxx = vx.x;
  vxy = vx.y;
  vxz = vx.z;

  float vyx = vy.x;
  float vyy = vy.y;
  float vyz = vy.z;

  vzx = vz.x;
  vzy = vz.y;
  vzz = vz.z;

  float4 delta = {dx, dy, dz, 0.0f};

  float4 mx = (float4)(vxx, vyx, vzx, smx);
  float4 my = (float4)(vxy, vyy, vzy, smy);
  float4 mz = (float4)(vxz, vyz, vzz, smz);
  float4 mw = (float4)(0.0, 0.0, 0.0, 1.0f);

  float4 delta_mtx = (float4)((dot(delta, mx)), (dot(delta, my)), (dot(delta, mz)), (dot(delta, mw)));

  smx += delta_mtx.x;
  smy += delta_mtx.y;
  smz += delta_mtx.z;

  smx = ptx + ((smx - ptx) * weights[hook(7, positionId)] * envelope);
  smy = pty + ((smy - pty) * weights[hook(7, positionId)] * envelope);
  smz = ptz + ((smz - ptz) * weights[hook(7, positionId)] * envelope);

  finalPts[hook(0, posOffset)] = smx;
  finalPts[hook(0, posOffset + 1)] = smy;
  finalPts[hook(0, posOffset + 2)] = smz;
}