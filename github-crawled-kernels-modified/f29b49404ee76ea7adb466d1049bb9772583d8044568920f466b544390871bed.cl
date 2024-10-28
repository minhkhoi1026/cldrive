//{"childId_memStatusBit":0}
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
kernel void clearMemoryBit(global int* childId_memStatusBit) {
  atomic_and(childId_memStatusBit + get_global_id(0), 0x3FFFFFFF);
}