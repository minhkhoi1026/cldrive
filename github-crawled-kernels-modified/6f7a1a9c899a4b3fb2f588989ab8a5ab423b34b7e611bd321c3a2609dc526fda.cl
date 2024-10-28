//{"Height":2,"ImIn":0,"ImOut":1,"LocalData":6,"LocalMask":7,"Mask":5,"Radius":4,"Width":3}
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
    if (Mask[hook(5, Index(Y, X, H, W))] != 0) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

kernel void MeanFilterPad_V_Transpose(global int2* ImIn, global uchar* ImOut, int Height, int Width, int Radius) {
  local int LocalData[2 * 32];
  local int LocalMask[2 * 32];

  const int GlobalPosY = get_global_id(0) + Radius;
  const int GlobalPosX = get_global_id(1) + Radius;

  const int LocalPosY = get_local_id(0);

  const int LocalSizeY = get_local_size(0);

  int Sum = 0;
  double DSum = 0.0;
  int Counter = 0;
  int2 Temp;
  int Row = GlobalPosY - Radius;

  Temp = ImIn[hook(0, IndexTranspose(Row, GlobalPosX, Height, Width))];
  LocalData[hook(6, LocalPosY)] = Temp.x;
  LocalMask[hook(7, LocalPosY)] = Temp.y;

  for (; Row <= GlobalPosY + Radius; Row += LocalSizeY) {
    Temp = ImIn[hook(0, IndexTranspose(Row + LocalSizeY, GlobalPosX, Height, Width))];
    LocalData[hook(6, LocalPosY + LocalSizeY)] = Temp.x;
    LocalMask[hook(7, LocalPosY + LocalSizeY)] = Temp.y;

    barrier(0x01);

    for (int i = 0; i < LocalSizeY && (Row + i <= GlobalPosY + Radius); ++i) {
      Sum = Sum + LocalData[hook(6, LocalPosY + i)];
      Counter = Counter + LocalMask[hook(7, LocalPosY + i)];
    }

    barrier(0x01);

    LocalData[hook(6, LocalPosY)] = LocalData[hook(6, LocalPosY + LocalSizeY)];
    LocalMask[hook(7, LocalPosY)] = LocalMask[hook(7, LocalPosY + LocalSizeY)];
  }

  if (Counter > 0) {
    DSum = (double)(Sum);
    DSum = DSum / (double)(Counter);
  }

  ImOut[hook(1, Index(GlobalPosY, GlobalPosX, Height, Width))] = convert_uchar(DSum);
}