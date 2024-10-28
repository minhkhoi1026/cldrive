//{"aabbMax":13,"aabbMin":12,"boneIndices":2,"boneWeights":1,"edgeScaleFactor":5,"lightDirection":4,"localMatrices":0,"materialEdgeSize":3,"nvertices":6,"offsetEdgeVertex":11,"offsetMorphDelta":10,"offsetNormal":9,"offsetPosition":8,"strideSize":7,"vertices":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 matrixMultVector4(const float16* m, const float4* v) {
  return (float4)(dot(m->s048c, *v) + m->s3, dot(m->s159d, *v) + m->s7, dot(m->s26ae, *v) + m->sb, 1.0);
}

float4 matrixMultVector3(const float16* m, const float4* v) {
  return (float4)(dot((float4)(m->s048, 0.0), *v), dot((float4)(m->s159, 0.0), *v), dot((float4)(m->s26a, 0.0), *v), 0.0);
}

void transformVertexBdef1(const float16* transform, const float4* inPosition, const float4* inNormal, global float4* outPosition, global float4* outNormal) {
  *outPosition = matrixMultVector4(transform, inPosition);
  *outNormal = matrixMultVector3(transform, inNormal);
}

void transformVertexBdef2(const float16* transformA, const float16* transformB, const float4* inPosition, const float4* inNormal, const float weight, global float4* outPosition, global float4* outNormal) {
  const float4 v1 = matrixMultVector4(transformA, inPosition);
  const float4 v2 = matrixMultVector4(transformB, inPosition);
  const float4 n1 = matrixMultVector3(transformA, inNormal);
  const float4 n2 = matrixMultVector3(transformB, inNormal);
  const float s = 1.0f - weight;
  *outPosition = fma(s, v2, weight * v1);
  *outNormal = fma(s, n2, weight * n1);
}

kernel void performSkinning2(const global float* localMatrices, const global float* boneWeights, const global int* boneIndices, const global float* materialEdgeSize, const float4 lightDirection, const float edgeScaleFactor, const int nvertices, const int strideSize, const int offsetPosition, const int offsetNormal, const int offsetMorphDelta, const int offsetEdgeVertex, global float* aabbMin, global float* aabbMax, global float4* vertices) {
  int id = get_global_id(0);
  if (id < nvertices) {
    const int strideOffset = strideSize * id;
    global float4* positionPtr = &vertices[hook(14, strideOffset + offsetPosition)];
    global float4* normalPtr = &vertices[hook(14, strideOffset + offsetNormal)];
    const float4 position4 = *positionPtr + vertices[hook(14, strideOffset + offsetMorphDelta)];
    const float4 normal4 = *normalPtr;
    const float edgeSize = normal4.w * materialEdgeSize[hook(3, id)] * edgeScaleFactor;
    const int4 boneIndex = vload4(id, boneIndices);
    const float4 weight = vload4(id, boneWeights);
    const float4 position = (float4)(position4.xyz, 1.0);
    const float4 normal = (float4)(normal4.xyz, 0.0);
    if (boneIndex.w >= 0) {
      float16 transform1 = vload16(boneIndex.x, localMatrices);
      float16 transform2 = vload16(boneIndex.y, localMatrices);
      float16 transform3 = vload16(boneIndex.z, localMatrices);
      float16 transform4 = vload16(boneIndex.w, localMatrices);
      float4 v1 = matrixMultVector4(&transform1, &position);
      float4 v2 = matrixMultVector4(&transform2, &position);
      float4 v3 = matrixMultVector4(&transform3, &position);
      float4 v4 = matrixMultVector4(&transform4, &position);
      float4 n1 = matrixMultVector3(&transform1, &normal);
      float4 n2 = matrixMultVector3(&transform2, &normal);
      float4 n3 = matrixMultVector3(&transform3, &normal);
      float4 n4 = matrixMultVector3(&transform4, &normal);
      float4 position2 = fma(weight.x, v1, fma(weight.y, v2, fma(weight.z, v3, weight.w * v4)));
      float4 normal2 = fma(weight.x, n1, fma(weight.y, n2, fma(weight.z, n3, weight.w * n4)));
      *positionPtr = position2;
      *normalPtr = normal2;
    } else if (boneIndex.y >= 0) {
      const float w = weight.x;
      if (w == 1.0) {
        const float16 transform = vload16(boneIndex.x, localMatrices);
        transformVertexBdef1(&transform, &position, &normal, positionPtr, normalPtr);
      } else if (w == 0.0) {
        const float16 transform = vload16(boneIndex.y, localMatrices);
        transformVertexBdef1(&transform, &position, &normal, positionPtr, normalPtr);
      } else {
        const float16 transformA = vload16(boneIndex.x, localMatrices);
        const float16 transformB = vload16(boneIndex.y, localMatrices);
        transformVertexBdef2(&transformA, &transformB, &position, &normal, w, positionPtr, normalPtr);
      }
    } else {
      const float16 transform = vload16(boneIndex.x, localMatrices);
      transformVertexBdef1(&transform, &position, &normal, positionPtr, normalPtr);
    }
    const float vertexId = position4.w;
    vertices[hook(14, strideOffset + offsetPosition)].w = vertexId;
    vertices[hook(14, strideOffset + offsetEdgeVertex)] = fma(*normalPtr, edgeSize, *positionPtr);
    barrier(0x02 | 0x01);
    vstore4(min(vload4(0, aabbMin), *positionPtr), 0, aabbMin);
    vstore4(max(vload4(0, aabbMax), *positionPtr), 0, aabbMax);
  }
}