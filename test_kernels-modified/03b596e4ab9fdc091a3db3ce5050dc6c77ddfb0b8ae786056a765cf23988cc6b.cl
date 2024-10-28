//{"count":3,"dir":0,"dira":8,"dirb":11,"dirc":7,"i":4,"indices":2,"o":1,"oa":10,"ob":12,"oc":9,"tempb":5,"tempc":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void raySort(global float* dir, global float* o, global int* indices, int count, int i) {
  int iGID = get_global_id(0);

  if (i == 0) {
    while (iGID < count) {
      indices[hook(2, iGID)] = iGID;
      iGID += get_global_size(0) + 1;
    }

    iGID = get_global_id(0);
  }

  if (3 * iGID + 2 + i > count)
    return;

  float4 dira, dirb, dirc, oa, ob, oc;
  float4 tempb, tempc;
  float distb, distc;
  int temp;
  unsigned int a1, a2, a3, b1, b2, b3, c1, c2, c3;
  if (i % 4 == 0) {
    a1 = 3;
    a2 = 4;
    a3 = 5;
    b1 = 0;
    b2 = 1;
    b3 = 2;
    c1 = 6;
    c2 = 7;
    c3 = 8;
  }
  if (i % 4 == 1) {
    a1 = 6;
    a2 = 7;
    a3 = 8;
    b1 = 3;
    b2 = 4;
    b3 = 5;
    c1 = 9;
    c2 = 10;
    c3 = 11;
  }
  if (i % 4 == 2) {
    a1 = 9;
    a2 = 10;
    a3 = 11;
    b1 = 6;
    b2 = 7;
    b3 = 8;
    c1 = 12;
    c2 = 13;
    c3 = 14;
  }
  if (i % 4 == 3) {
    a1 = 12;
    a2 = 13;
    a3 = 14;
    b1 = 9;
    b2 = 10;
    b3 = 11;
    c1 = 15;
    c2 = 16;
    c3 = 17;
  }

  dira = (float4)(dir[hook(0, 9 * iGID + a1)], dir[hook(0, 9 * iGID + a2)], dir[hook(0, 9 * iGID + a3)], 0);
  dirb = (float4)(dir[hook(0, 9 * iGID + b1)], dir[hook(0, 9 * iGID + b2)], dir[hook(0, 9 * iGID + b3)], 0);
  dirc = (float4)(dir[hook(0, 9 * iGID + c1)], dir[hook(0, 9 * iGID + c2)], dir[hook(0, 9 * iGID + c3)], 0);
  oa = (float4)(o[hook(1, 9 * iGID + a1)], o[hook(1, 9 * iGID + a2)], o[hook(1, 9 * iGID + a3)], 0);
  ob = (float4)(o[hook(1, 9 * iGID + b1)], o[hook(1, 9 * iGID + b2)], o[hook(1, 9 * iGID + b3)], 0);
  oc = (float4)(o[hook(1, 9 * iGID + c1)], o[hook(1, 9 * iGID + c2)], o[hook(1, 9 * iGID + c3)], 0);

  tempb = fdim(oa, ob);
  distb = tempb[hook(5, 0)] + tempb[hook(5, 1)] + tempb[hook(5, 2)];

  tempc = fdim(oa, oc);
  distc = tempc[hook(6, 0)] + tempc[hook(6, 1)] + tempc[hook(6, 2)];
  temp = indices[hook(2, 3 * iGID + i)];
  if (distb > distc) {
    indices[hook(2, 3 * iGID + i)] = indices[hook(2, 3 * iGID + 2 + i)];
    indices[hook(2, 3 * iGID + 2 + i)] = temp;
    dir[hook(0, 9 * iGID + a1)] = dirc[hook(7, 0)];
    dir[hook(0, 9 * iGID + a2)] = dirc[hook(7, 1)];
    dir[hook(0, 9 * iGID + a3)] = dirc[hook(7, 2)];
    dir[hook(0, 9 * iGID + c1)] = dira[hook(8, 0)];
    dir[hook(0, 9 * iGID + c2)] = dira[hook(8, 1)];
    dir[hook(0, 9 * iGID + c3)] = dira[hook(8, 2)];
    o[hook(1, 9 * iGID + a1)] = oc[hook(9, 0)];
    o[hook(1, 9 * iGID + a2)] = oc[hook(9, 1)];
    o[hook(1, 9 * iGID + a3)] = oc[hook(9, 2)];
    o[hook(1, 9 * iGID + c1)] = oa[hook(10, 0)];
    o[hook(1, 9 * iGID + c2)] = oa[hook(10, 1)];
    o[hook(1, 9 * iGID + c3)] = oa[hook(10, 2)];
  } else {
    indices[hook(2, 3 * iGID + i)] = indices[hook(2, 3 * iGID + 1 + i)];
    indices[hook(2, 3 * iGID + 1 + i)] = temp;
    dir[hook(0, 9 * iGID + a1)] = dirb[hook(11, 0)];
    dir[hook(0, 9 * iGID + a2)] = dirb[hook(11, 1)];
    dir[hook(0, 9 * iGID + a3)] = dirb[hook(11, 2)];
    dir[hook(0, 9 * iGID + b1)] = dira[hook(8, 0)];
    dir[hook(0, 9 * iGID + b2)] = dira[hook(8, 1)];
    dir[hook(0, 9 * iGID + b3)] = dira[hook(8, 2)];
    o[hook(1, 9 * iGID + a1)] = ob[hook(12, 0)];
    o[hook(1, 9 * iGID + a2)] = ob[hook(12, 1)];
    o[hook(1, 9 * iGID + a3)] = ob[hook(12, 2)];
    o[hook(1, 9 * iGID + b1)] = oa[hook(10, 0)];
    o[hook(1, 9 * iGID + b2)] = oa[hook(10, 1)];
    o[hook(1, 9 * iGID + b3)] = oa[hook(10, 2)];
  }
}