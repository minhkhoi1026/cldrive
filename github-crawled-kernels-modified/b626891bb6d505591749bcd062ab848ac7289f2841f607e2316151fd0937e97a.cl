//{"Cluster_Indices":0,"DATA_D":8,"DATA_H":7,"DATA_W":6,"Data":2,"Mask":3,"Updated":1,"contrast":5,"threshold":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int Calculate2DIndex(int x, int y, int DATA_W) {
  return x + y * DATA_W;
}

int Calculate3DIndex(int x, int y, int z, int DATA_W, int DATA_H) {
  return x + y * DATA_W + z * DATA_W * DATA_H;
}

int Calculate4DIndex(int x, int y, int z, int t, int DATA_W, int DATA_H, int DATA_D) {
  return x + y * DATA_W + z * DATA_W * DATA_H + t * DATA_W * DATA_H * DATA_D;
}

bool IsInsideVolume(int x, int y, int z, int DATA_W, int DATA_H, int DATA_D) {
  if (z < 0)
    return false;
  else if (z >= DATA_D)
    return false;
  else if (y < 0)
    return false;
  else if (y >= DATA_H)
    return false;
  else if (x < 0)
    return false;
  else if (x >= DATA_W)
    return false;
  else
    return true;
}

kernel void ClusterizeScan(global unsigned int* Cluster_Indices, volatile global float* Updated, global const float* Data, global const float* Mask, private float threshold, private int contrast, private int DATA_W, private int DATA_H, private int DATA_D) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(3, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] != 1.0f)
    return;

  if (Data[hook(2, Calculate4DIndex(x, y, z, contrast, DATA_W, DATA_H, DATA_D))] > threshold) {
    unsigned int label1, label2, temp;

    label2 = DATA_W * DATA_H * DATA_D * 3;

    label1 = Cluster_Indices[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))];

    if (IsInsideVolume(x - 1, y, z - 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x - 1, y, z - 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x - 1, y - 1, z - 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x - 1, y - 1, z - 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x - 1, y + 1, z - 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x - 1, y + 1, z - 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x, y, z - 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x, y, z - 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x, y - 1, z - 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x, y - 1, z - 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x, y + 1, z - 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x, y + 1, z - 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x + 1, y, z - 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x + 1, y, z - 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x + 1, y - 1, z - 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x + 1, y - 1, z - 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x + 1, y + 1, z - 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x + 1, y + 1, z - 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x - 1, y, z, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x - 1, y, z, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x - 1, y - 1, z, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x - 1, y - 1, z, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x - 1, y + 1, z, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x - 1, y + 1, z, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x, y - 1, z, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x, y - 1, z, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x, y + 1, z, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x, y + 1, z, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x + 1, y, z, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x + 1, y, z, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x + 1, y - 1, z, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x + 1, y - 1, z, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x + 1, y + 1, z, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x + 1, y + 1, z, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x - 1, y, z + 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x - 1, y, z + 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x - 1, y - 1, z + 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x - 1, y - 1, z + 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x - 1, y + 1, z + 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x - 1, y + 1, z + 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x, y, z + 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x, y, z + 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x, y - 1, z + 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x, y - 1, z + 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x, y + 1, z + 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x, y + 1, z + 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x + 1, y, z + 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x + 1, y, z + 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x + 1, y - 1, z + 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x + 1, y - 1, z + 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (IsInsideVolume(x + 1, y + 1, z + 1, DATA_W, DATA_H, DATA_D)) {
      temp = Cluster_Indices[hook(0, Calculate3DIndex(x + 1, y + 1, z + 1, DATA_W, DATA_H))];
      if (temp < label2) {
        label2 = temp;
      }
    }

    if (label2 < label1) {
      Cluster_Indices[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = label2;
      float one = 1.0f;
      atomic_xchg(Updated, one);
    }
  }
}