//{"FOV":7,"boundingRect":5,"childId_memStatusBit":6,"cornersArray":4,"debugOutput":10,"numberOfLevels":1,"pixels":2,"references":3,"renderingOrder":9,"texture":0,"topCubeId":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
bool boundingRectComputed(int childId_memStatusBit);
bool lockIfNotAlready(global int* childId_memStatusBit, int id);
bool isInBoundingRect(int4 boundingRect, int2 imgCoord);
int getChildId(int childId_memStatusBit);
int numberOfHighBitsWithinBoundary(uchar map, int boundary);
void computeSubcorners(uchar reference, int cubeId, global float3* cornersArray, global int4* boundingRect, global int* FOV, global int* childId_memStatusBit, global float3* debugOutput);
void pushStack(private int* levelStack, private int* idStack, private int* stackCursor, int levelToInsert, int idToInsert);
void popStack(private int* levelStack, private int* idStack, private int* stackCursor, private int* level, private int* cubeId);
kernel void render(write_only image2d_t texture, global int* numberOfLevels, global float3* pixels, global uchar* references, global float3* cornersArray, global int4* boundingRect, global int* childId_memStatusBit, global int* FOV, global int* topCubeId, global uchar* renderingOrder, global float3* debugOutput) {
  float4 pixelValue;
  int2 pixelCoord = (int2)(get_global_id(0), get_global_id(1));

  int currentCubeId = topCubeId[hook(8, 0)] - 1;

  int levelStack[88];
  int idStack[88];
  int stackCursor = -1;

  for (int level = numberOfLevels[hook(1, 0)]; level >= 0; level--) {
    if (level == 0) {
      pixelValue = (float4)(pixels[hook(2, currentCubeId)], 1.0);
      break;
    }

    if (!isInBoundingRect(boundingRect[hook(5, currentCubeId)], pixelCoord)) {
      if (stackCursor < 0) {
        pixelValue = (float4)(0.0, 0.0, 0.0, 1.0);
        break;
      } else {
        popStack(&levelStack, &idStack, &stackCursor, &level, &currentCubeId);
        continue;
      }
    }

    if ((childId_memStatusBit[hook(6, currentCubeId)] & 0x80000000) == 0 && lockIfNotAlready(childId_memStatusBit, currentCubeId)) {
      computeSubcorners(references[hook(3, currentCubeId)], currentCubeId, cornersArray, boundingRect, FOV, childId_memStatusBit, debugOutput);
    }

    while ((childId_memStatusBit[hook(6, currentCubeId)] & 0x80000000) == 0) {
    }

    uchar cubeMap = references[hook(3, currentCubeId)];
    int childIdBase = getChildId(childId_memStatusBit[hook(6, currentCubeId)]);
    int offset;
    for (int i = 7; i >= 0; i--) {
      if ((cubeMap & (0x01 << renderingOrder[hook(9, i)])) != 0) {
        offset = numberOfHighBitsWithinBoundary(cubeMap, renderingOrder[hook(9, i)]);
        pushStack(&levelStack, &idStack, &stackCursor, level, childIdBase + offset);
      }
    }

    popStack(&levelStack, &idStack, &stackCursor, &level, &currentCubeId);
  }

  write_imagef(texture, pixelCoord, pixelValue);
}