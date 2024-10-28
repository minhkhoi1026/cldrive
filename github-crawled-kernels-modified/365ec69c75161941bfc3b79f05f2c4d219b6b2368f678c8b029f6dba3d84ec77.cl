//{"baryCoords":10,"bindMatrices":11,"drivenInvMatrix":14,"drivenInvMatrixTransposed":18,"drivenMatrixTransposed":17,"drivenWorldMatrix":13,"driverNormals":3,"driverPoints":2,"envelope":15,"finalPos":0,"initialPos":1,"paintWeights":4,"positionCount":16,"sampleCounts":5,"sampleIds":7,"sampleOffsets":6,"sampleWeights":8,"scaleMatrix":12,"triangleVerts":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cvwrap(global float* finalPos, global const float* initialPos, global const float* driverPoints, global const float* driverNormals, global const float* paintWeights, global const int* sampleCounts, global const int* sampleOffsets, global const int* sampleIds, global const float* sampleWeights, global const int* triangleVerts, global const float* baryCoords, global const float4* bindMatrices, global const float4* scaleMatrix, global const float* drivenWorldMatrix, global const float* drivenInvMatrix, const float envelope, const unsigned int positionCount) {
  unsigned int positionId = get_global_id(0);
  if (positionId >= positionCount) {
    return;
  }
  unsigned int positionOffset = positionId * 3;
  float baryA = baryCoords[hook(10, positionOffset)];
  float baryB = baryCoords[hook(10, positionOffset + 1)];
  float baryC = baryCoords[hook(10, positionOffset + 2)];
  int triVertA = triangleVerts[hook(9, positionOffset)] * 3;
  int triVertB = triangleVerts[hook(9, positionOffset + 1)] * 3;
  int triVertC = triangleVerts[hook(9, positionOffset + 2)] * 3;
  float originX = driverPoints[hook(2, triVertA)] * baryA + driverPoints[hook(2, triVertB)] * baryB + driverPoints[hook(2, triVertC)] * baryC;
  float originY = driverPoints[hook(2, triVertA + 1)] * baryA + driverPoints[hook(2, triVertB + 1)] * baryB + driverPoints[hook(2, triVertC + 1)] * baryC;
  float originZ = driverPoints[hook(2, triVertA + 2)] * baryA + driverPoints[hook(2, triVertB + 2)] * baryB + driverPoints[hook(2, triVertC + 2)] * baryC;
  float hitNormalX = driverNormals[hook(3, triVertA)] * baryA + driverNormals[hook(3, triVertB)] * baryB + driverNormals[hook(3, triVertC)] * baryC;
  float hitNormalY = driverNormals[hook(3, triVertA + 1)] * baryA + driverNormals[hook(3, triVertB + 1)] * baryB + driverNormals[hook(3, triVertC + 1)] * baryC;
  float hitNormalZ = driverNormals[hook(3, triVertA + 2)] * baryA + driverNormals[hook(3, triVertB + 2)] * baryB + driverNormals[hook(3, triVertC + 2)] * baryC;

  int offset = sampleOffsets[hook(6, positionId)];
  int hitIndex = offset + sampleCounts[hook(5, positionId)] - 1;
  float hitWeight = sampleWeights[hook(8, hitIndex)];
  float normalX = hitNormalX * hitWeight;
  float normalY = hitNormalY * hitWeight;
  float normalZ = hitNormalZ * hitWeight;
  for (int j = offset; j < hitIndex; j++) {
    float sw = sampleWeights[hook(8, j)];
    int sampleId = sampleIds[hook(7, j)] * 3;
    normalX += driverNormals[hook(3, sampleId)] * sw;
    normalY += driverNormals[hook(3, sampleId + 1)] * sw;
    normalZ += driverNormals[hook(3, sampleId + 2)] * sw;
  }

  float upX = ((driverPoints[hook(2, triVertA)] + driverPoints[hook(2, triVertB)]) * 0.5f) - originX;
  float upY = ((driverPoints[hook(2, triVertA + 1)] + driverPoints[hook(2, triVertB + 1)]) * 0.5f) - originY;
  float upZ = ((driverPoints[hook(2, triVertA + 2)] + driverPoints[hook(2, triVertB + 2)]) * 0.5f) - originZ;
  float3 up = (float3)(upX, upY, upZ);
  float3 normal = (float3)(normalX, normalY, normalZ);
  normal = normalize(normal);
  float3 unitUp = normalize(up);
  float upLength = length(up);
  if (fabs(dot(unitUp, normal) - 1.0f) < 0.001f || upLength < 0.0001f) {
    for (int j = offset; j < hitIndex; j++) {
      float sw = sampleWeights[hook(8, j)];
      int sampleId = sampleIds[hook(7, j)] * 3;
      up.x -= (driverPoints[hook(2, sampleId)] - originX) * sw;
      up.y -= (driverPoints[hook(2, sampleId + 1)] - originY) * sw;
      up.z -= (driverPoints[hook(2, sampleId + 2)] - originZ) * sw;
      unitUp = normalize(up);
      upLength = length(up);
      if (fabs(dot(unitUp, normal) - 1.0f) > 0.001f && upLength > 0.0001f) {
        break;
      }
    }
    up = normalize(up);
  } else {
    up = unitUp;
  }

  float3 x = cross(normal, up);
  float3 z = cross(x, normal);
  x = normalize(x);
  z = normalize(z);

  float4 matrix0 = (float4)(x.x, normal.x, z.x, originX);
  float4 matrix1 = (float4)(x.y, normal.y, z.y, originY);
  float4 matrix2 = (float4)(x.z, normal.z, z.z, originZ);
  float4 matrix3 = (float4)(0.0f, 0.0f, 0.0f, 1.0f);

  float4 scaleMatrix0 = (float4)(dot(scaleMatrix[hook(12, 0)], matrix0), dot(scaleMatrix[hook(12, 0)], matrix1), dot(scaleMatrix[hook(12, 0)], matrix2), dot(scaleMatrix[hook(12, 0)], matrix3));
  float4 scaleMatrix1 = (float4)(dot(scaleMatrix[hook(12, 1)], matrix0), dot(scaleMatrix[hook(12, 1)], matrix1), dot(scaleMatrix[hook(12, 1)], matrix2), dot(scaleMatrix[hook(12, 1)], matrix3));
  float4 scaleMatrix2 = (float4)(dot(scaleMatrix[hook(12, 2)], matrix0), dot(scaleMatrix[hook(12, 2)], matrix1), dot(scaleMatrix[hook(12, 2)], matrix2), dot(scaleMatrix[hook(12, 2)], matrix3));
  float4 scaleMatrix3 = (float4)(dot(scaleMatrix[hook(12, 3)], matrix0), dot(scaleMatrix[hook(12, 3)], matrix1), dot(scaleMatrix[hook(12, 3)], matrix2), dot(scaleMatrix[hook(12, 3)], matrix3));

  float4 smX = (float4)(scaleMatrix0.x, scaleMatrix1.x, scaleMatrix2.x, scaleMatrix3.x);
  float4 smY = (float4)(scaleMatrix0.y, scaleMatrix1.y, scaleMatrix2.y, scaleMatrix3.y);
  float4 smZ = (float4)(scaleMatrix0.z, scaleMatrix1.z, scaleMatrix2.z, scaleMatrix3.z);
  float4 smW = (float4)(scaleMatrix0.w, scaleMatrix1.w, scaleMatrix2.w, scaleMatrix3.w);

  float4 bm0 = bindMatrices[hook(11, positionId * 4)];
  float4 bm1 = bindMatrices[hook(11, positionId * 4 + 1)];
  float4 bm2 = bindMatrices[hook(11, positionId * 4 + 2)];
  float4 bm3 = bindMatrices[hook(11, positionId * 4 + 3)];
  float4 m0 = (float4)(dot(bm0, smX), dot(bm0, smY), dot(bm0, smZ), dot(bm0, smW));
  float4 m1 = (float4)(dot(bm1, smX), dot(bm1, smY), dot(bm1, smZ), dot(bm1, smW));
  float4 m2 = (float4)(dot(bm2, smX), dot(bm2, smY), dot(bm2, smZ), dot(bm2, smW));
  float4 m3 = (float4)(dot(bm3, smX), dot(bm3, smY), dot(bm3, smZ), dot(bm3, smW));

  float4 initialPosition = (float4)(initialPos[hook(1, positionOffset)], initialPos[hook(1, positionOffset + 1)], initialPos[hook(1, positionOffset + 2)], 1.0f);

  float4 drivenMatrixTransposed[4];
  float4 drivenInvMatrixTransposed[4];
  for (unsigned int i = 0; i < 4; i++) {
    drivenMatrixTransposed[hook(17, i)] = (float4)(drivenWorldMatrix[hook(13, i)], drivenWorldMatrix[hook(13, i + 4)], drivenWorldMatrix[hook(13, i + 8)], drivenWorldMatrix[hook(13, i + 12)]);
    drivenInvMatrixTransposed[hook(18, i)] = (float4)(drivenInvMatrix[hook(14, i)], drivenInvMatrix[hook(14, i + 4)], drivenInvMatrix[hook(14, i + 8)], drivenInvMatrix[hook(14, i + 12)]);
  }

  float4 worldPt = (float4)(dot(initialPosition, drivenMatrixTransposed[hook(17, 0)]), dot(initialPosition, drivenMatrixTransposed[hook(17, 1)]), dot(initialPosition, drivenMatrixTransposed[hook(17, 2)]), dot(initialPosition, drivenMatrixTransposed[hook(17, 3)]));
  worldPt = (float4)(dot(worldPt, (float4)(m0.x, m1.x, m2.x, m3.x)), dot(worldPt, (float4)(m0.y, m1.y, m2.y, m3.y)), dot(worldPt, (float4)(m0.z, m1.z, m2.z, m3.z)), dot(worldPt, (float4)(m0.w, m1.w, m2.w, m3.w)));
  float3 newPt = (float3)(dot(worldPt, drivenInvMatrixTransposed[hook(18, 0)]), dot(worldPt, drivenInvMatrixTransposed[hook(18, 1)]), dot(worldPt, drivenInvMatrixTransposed[hook(18, 2)]));

  float weight = paintWeights[hook(4, positionId)] * envelope;
  finalPos[hook(0, positionOffset)] = initialPosition.x + ((newPt.x - initialPosition.x) * weight);
  finalPos[hook(0, positionOffset + 1)] = initialPosition.y + ((newPt.y - initialPosition.y) * weight);
  finalPos[hook(0, positionOffset + 2)] = initialPosition.z + ((newPt.z - initialPosition.z) * weight);
}