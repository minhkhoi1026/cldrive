//{"I":0,"L":2,"O":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blur2D_local(global float* I, global float* O) {
  local float L[18 * 18];
  const int2 iG = (int2)(get_global_id(0) + 1, get_global_id(1) + 1);
  const int2 nG = (int2)(get_global_size(0) + 2, get_global_size(1) + 2);
  const int2 iL = (int2)(get_local_id(0) + 1, get_local_id(1) + 1);
  const int2 nL = (int2)(get_local_size(0) + 2, get_local_size(1) + 2);
  const int2 iGR = (int2)(get_group_id(0), get_group_id(1));

  switch (get_local_id(1)) {
    case 4:
      switch (get_local_id(0)) {
        case 0:
          L[hook(2, 0)] = I[hook(0, nG.x * get_group_id(1) * get_local_size(1) + get_group_id(0) * get_local_size(0))];
          break;
        case 1:
          L[hook(2, 18 - 1)] = I[hook(0, nG.x * get_group_id(1) * get_local_size(1) + get_group_id(0) * get_local_size(0) + (18 - 1))];
          break;
        case 2:
          L[hook(2, (18 - 1) * 18)] = I[hook(0, nG.x * (get_group_id(1) * get_local_size(1) + (18 - 1)) + get_group_id(0) * get_local_size(0))];
          break;
        case 3:
          L[hook(2, 18 * 18 - 1)] = I[hook(0, nG.x * (get_group_id(1) * get_local_size(1) + (18 - 1)) + get_group_id(0) * get_local_size(0) + (18 - 1))];
          break;
      }

    case 0:
      L[hook(2, iL.x)] = I[hook(0, nG.x * get_group_id(1) * get_local_size(1) + iG.x)];
      break;
    case 1:
      L[hook(2, 18 * (18 - 1) + iL.x)] = I[hook(0, nG.x * (get_group_id(1) * get_local_size(1) + (18 - 1)) + iG.x)];
      break;
    case 2:
      L[hook(2, 18 * iL.x)] = I[hook(0, nG.x * (get_group_id(1) * get_local_size(1) + get_local_id(0)) + get_group_id(0) * get_local_size(0))];
      break;
    case 3:
      L[hook(2, 18 * iL.x + (18 - 1))] = I[hook(0, nG.x * (get_group_id(1) * get_local_size(1) + get_local_id(0)) + (get_group_id(0) * get_local_size(0) + (18 - 1)))];
      break;
  }

  int ig = iG.y * nG.x + iG.x;
  int il = iL.y * nL.x + iL.x;
  L[hook(2, il)] = I[hook(0, ig)];

  barrier(0x01);

  O[hook(1, ig)] = (L[hook(2, il - 18 - 1)] + L[hook(2, il - 18)] + L[hook(2, il - 18 + 1)] + L[hook(2, il - 1)] + L[hook(2, il)] + L[hook(2, il + 1)] + L[hook(2, il + 18 - 1)] + L[hook(2, il + 18)] + L[hook(2, il + 18 + 1)]) / 9.0f;
}