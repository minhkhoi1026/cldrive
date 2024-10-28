//{"ByteAlign":6,"Height":3,"ImIn":0,"ImMask":1,"ImOut":2,"LocalData":8,"LocalMask":9,"Mask":7,"Radius":5,"Width":4}
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
    if (Mask[hook(7, Index(Y, X, H, W))] != 0) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

kernel void MeanFilterPadAligned_H(global const uchar* ImIn, global const uchar* ImMask, global int2* ImOut, int Height, int Width, int Radius, int ByteAlign) {
  local int LocalData[2 * 32];
  local int LocalMask[2 * 32];

  const int GlobalPosY = get_global_id(1) + Radius + ByteAlign;
  const int GlobalPosX = get_global_id(0) + Radius + ByteAlign;

  const int LocalPosX = get_local_id(0);

  const int LocalSizeX = get_local_size(0);

  int Sum = 0;
  int2 DSum = (int2)(0, 0);
  int Counter = 0;

  int Col = GlobalPosX - Radius;

  LocalData[hook(8, LocalPosX)] = convert_int(ImIn[hook(0, Index(GlobalPosY, Col, Height, Width))]);
  LocalMask[hook(9, LocalPosX)] = convert_int(ImMask[hook(1, Index(GlobalPosY, Col, Height, Width))]);

  for (; Col <= GlobalPosX + Radius; Col += LocalSizeX) {
    LocalData[hook(8, LocalPosX + LocalSizeX)] = convert_int(ImIn[hook(0, Index(GlobalPosY, Col + LocalSizeX, Height, Width))]);
    LocalMask[hook(9, LocalPosX + LocalSizeX)] = convert_int(ImMask[hook(1, Index(GlobalPosY, Col + LocalSizeX, Height, Width))]);

    barrier(0x01);

    for (int j = 0; j < LocalSizeX && (Col + j <= GlobalPosX + Radius); ++j) {
      Sum = LocalData[hook(8, LocalPosX + j)] + Sum;
      Counter = Counter + LocalMask[hook(9, LocalPosX + j)];
    }

    barrier(0x01);

    LocalData[hook(8, LocalPosX)] = LocalData[hook(8, LocalPosX + LocalSizeX)];
    LocalMask[hook(9, LocalPosX)] = LocalMask[hook(9, LocalPosX + LocalSizeX)];
  }

  DSum = (int2)(Sum, Counter);

  ImOut[hook(2, Index(GlobalPosY, GlobalPosX, Height, Width))] = DSum;
}