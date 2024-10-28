//{"input":0,"listsize":2,"result":1}
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

kernel void mergeSortFirst(global float4* input, global float4* result, const int listsize) {
  int bx = get_global_id(0) / get_local_size(0);

  if (bx * get_local_size(0) + get_local_id(0) < listsize / 4) {
    float4 r = input[hook(0, bx * get_local_size(0) + get_local_id(0))];
    result[hook(1, bx * get_local_size(0) + get_local_id(0))] = sortElem(r);
  }
}