//{"Height":3,"ImIn":0,"ImOut":2,"Mask":1,"Radius":5,"Width":4}
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
    if (Mask[hook(1, Index(Y, X, H, W))] != 0) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

kernel void MeanFilter_WithMask_1(global const uchar4* ImIn, global const uchar* Mask, global uchar4* ImOut, int Height, int Width, int Radius) {
  local int4 LocalData[64];
  local int LocalMask[64];

  const int GlobalPosY = get_global_id(1);
  const int GlobalPosX = get_global_id(0);

  int4 Sum = (int4)(0);
  int8 DSum = (int8)(0);
  int4 Counter = 0;

  for (int j = -Radius; j <= Radius; ++j) {
    int row = GlobalPosY + j;
    for (int i = -Radius; i <= Radius; ++i) {
      int col = GlobalPosX + i;
      if (IsInside(row, col, Height, Width)) {
        Sum += convert_int4(ImIn[hook(0, Index(row, col, Height, Width))]);
        Counter += (int4)(1);
      }
    }
  }

  if (Counter.x > 0) {
    DSum.lo = Sum;
    DSum.hi = Counter;
  }

  if (IsInside(GlobalPosY, GlobalPosX, Height, Width)) {
    ImOut[hook(2, Index(GlobalPosY, GlobalPosX, Height, Width))] = convert_uchar4(DSum.lo / DSum.hi);
  }
}