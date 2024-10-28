//{"constStartAddr":2,"finalStartAddr":4,"nullElems":3,"orig":0,"result":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 sortElem(float4 r) {
  float4 nr;

  nr.x = (r.x > r.y) ? r.y : r.x;
  nr.y = (r.y > r.x) ? r.y : r.x;
  nr.z = (r.z > r.w) ? r.w : r.z;
  nr.w = (r.w > r.z) ? r.w : r.z;

  r.x = (nr.x > nr.z) ? nr.z : nr.x;
  r.y = (nr.y > nr.w) ? nr.w : nr.y;
  r.z = (nr.z > nr.x) ? nr.z : nr.x;
  r.w = (nr.w > nr.y) ? nr.w : nr.y;

  nr.x = r.x;
  nr.y = (r.y > r.z) ? r.z : r.y;
  nr.z = (r.z > r.y) ? r.z : r.y;
  nr.w = r.w;
  return nr;
}

float4 getLowest(float4 a, float4 b) {
  a.x = (a.x < b.w) ? a.x : b.w;
  a.y = (a.y < b.z) ? a.y : b.z;
  a.z = (a.z < b.y) ? a.z : b.y;
  a.w = (a.w < b.x) ? a.w : b.x;
  return a;
}

float4 getHighest(float4 a, float4 b) {
  b.x = (a.w >= b.x) ? a.w : b.x;
  b.y = (a.z >= b.y) ? a.z : b.y;
  b.z = (a.y >= b.z) ? a.y : b.z;
  b.w = (a.x >= b.w) ? a.x : b.w;
  return b;
}

kernel void mergepack(global float* orig, global float* result, constant int* constStartAddr, constant int* nullElems, constant int* finalStartAddr) {
  int idx = get_global_id(0);
  int division = get_group_id(1);

  if ((finalStartAddr[hook(4, division)] + idx) >= finalStartAddr[hook(4, division + 1)])
    return;
  result[hook(1, finalStartAddr[dhook(4, division) + idx)] = orig[hook(0, constStartAddr[dhook(2, division) * 4 + nullElems[dhook(3, division) + idx)];
}