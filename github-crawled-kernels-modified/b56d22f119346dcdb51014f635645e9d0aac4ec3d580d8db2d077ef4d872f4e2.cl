//{"Height":3,"ImIn":0,"ImMask":1,"ImOut":2,"LocalData":7,"LocalMask":8,"Mask":6,"Radius":5,"Width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int Index(int Y, int X, int H, int W) {
  return (Y * W) + X;
}

int IndexTranspose(int Y, int X, int H, int W) {
  return (X * H) + Y;
}

bool IsInside(int Y, int X, int H, int W) {
  if ((Y >= 0) && (Y < H)) {
    if ((X >= 0) && (X < W)) {
      return true;
    } else {
      return false;
    }
  }
  return false;
}

bool IsInsideTranspose(int Y, int X, int H, int W) {
  if ((Y >= 0) && (Y < H)) {
    if ((X >= 0) && (X < W)) {
      return true;
    } else {
      return false;
    }
  }
  return false;
}

bool IsInsideMask(int Y, int X, int H, int W, global const uchar* Mask) {
  if (IsInside(Y, X, H, W)) {
    if (Mask[hook(6, Index(Y, X, H, W))] != 0) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

kernel void MeanFilterPad_H(global const uchar4* ImIn, global const uchar* ImMask, global int8* ImOut, int Height, int Width, int Radius) {
  local int4 LocalData[2 * 32];
  local int LocalMask[2 * 32];

  const int GlobalPosY = get_global_id(1) + Radius;
  const int GlobalPosX = get_global_id(0) + Radius;

  const int LocalPosX = get_local_id(0);

  const int LocalSizeX = get_local_size(0);

  int4 Sum = 0;
  int8 DSum = (int8)(0);
  int4 Counter = 0;

  int Col = GlobalPosX - Radius;

  LocalData[hook(7, LocalPosX)] = convert_int4(ImIn[hook(0, Index(GlobalPosY, Col, Height, Width))]);
  LocalMask[hook(8, LocalPosX)] = convert_int(ImMask[hook(1, Index(GlobalPosY, Col, Height, Width))]);

  for (; Col <= GlobalPosX + Radius; Col += LocalSizeX) {
    LocalData[hook(7, LocalPosX + LocalSizeX)] = convert_int4(ImIn[hook(0, Index(GlobalPosY, Col + LocalSizeX, Height, Width))]);
    LocalMask[hook(8, LocalPosX + LocalSizeX)] = convert_int(ImMask[hook(1, Index(GlobalPosY, Col + LocalSizeX, Height, Width))]);

    barrier(0x01);

    for (int j = 0; j < LocalSizeX && (Col + j <= GlobalPosX + Radius); ++j) {
      Sum = LocalData[hook(7, LocalPosX + j)] + Sum;
      Counter = Counter + (int4)(LocalMask[hook(8, LocalPosX + j)]);
    }

    barrier(0x01);

    LocalData[hook(7, LocalPosX)] = LocalData[hook(7, LocalPosX + LocalSizeX)];
    LocalMask[hook(8, LocalPosX)] = LocalMask[hook(8, LocalPosX + LocalSizeX)];
  }

  DSum.lo = Sum;

  DSum.hi = Counter;

  ImOut[hook(2, Index(GlobalPosY, GlobalPosX, Height, Width))] = DSum;
}