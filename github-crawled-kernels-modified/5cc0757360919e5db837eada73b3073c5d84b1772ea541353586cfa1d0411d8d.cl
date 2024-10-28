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

kernel void MeanFilter_WithMask_H_NoLocal(global const uchar4* ImIn, global const uchar* Mask, global int8* ImOut, int Height, int Width, int Radius) {
  const int GlobalPosY = get_global_id(1);
  const int GlobalPosX = get_global_id(0);

  int4 Sum = 0;
  int8 DSum = (int8)(0);
  int4 Counter = 0;

  int Col = GlobalPosX - Radius;

  for (; Col <= GlobalPosX + Radius; Col += 1) {
    if (IsInsideMask(GlobalPosY, Col, Height, Width, Mask)) {
      Sum += convert_int4(ImIn[hook(0, Index(GlobalPosY, Col, Height, Width))]);
      Counter += (int4)(1);
    }
  }

  if (Counter.s0 > 0) {
    DSum.lo = convert_int4(Sum);

    DSum.hi = convert_int4(Counter);
  }

  if (IsInside(GlobalPosY, GlobalPosX, Height, Width))
    ImOut[hook(2, Index(GlobalPosY, GlobalPosX, Height, Width))] = DSum;
}