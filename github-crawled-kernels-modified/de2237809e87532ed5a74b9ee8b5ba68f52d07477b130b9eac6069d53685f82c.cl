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

kernel void MeanFilter_WithMask_V_NoLocal(global int8* ImIn, global const uchar* Mask, global uchar4* ImOut, int Height, int Width, int Radius) {
  const int GlobalPosY = get_global_id(0);
  const int GlobalPosX = get_global_id(1);

  int4 Sum = 0;
  double4 DSum = 0.0;
  int4 Counter = 0;
  int OffsetY = 0;
  int8 Temp;
  int Row = GlobalPosY - Radius;

  for (; Row <= GlobalPosY + Radius; Row += 1) {
    if (IsInside(Row, GlobalPosX, Height, Width)) {
      Temp = ImIn[hook(0, Index(Row, GlobalPosX, Height, Width))];
      Sum = Sum + Temp.lo;
      Counter = Counter + Temp.s4;
    }
  }

  if (Counter.x > 0) {
    DSum = convert_double4(Sum);
    DSum = DSum / convert_double4(Counter);
  }

  if (IsInsideMask(GlobalPosY, GlobalPosX, Height, Width, Mask)) {
    uchar4 out_val = convert_uchar4(DSum);

    out_val.w = 255;
    ImOut[hook(2, Index(GlobalPosY, GlobalPosX, Height, Width))] = out_val;
  } else if (IsInside(GlobalPosY, GlobalPosX, Height, Width))
    ImOut[hook(2, Index(GlobalPosY, GlobalPosX, Height, Width))] = (uchar4)(0);
}