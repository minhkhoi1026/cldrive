//{"adjacencyList":4,"alCopy":10,"blockSize":7,"cellValues":14,"cellValuesNew":16,"cipherText":1,"constantSize":9,"constantValue":3,"key":2,"keySchedule":11,"keySize":8,"left":12,"localLinkFunction":17,"plainText":0,"right":13,"temp":15,"vertexCount":5,"vertexEdgeCount":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant size_t kBlockSize = 256;
constant size_t kKeySize = 128;
constant unsigned char localLinkFunction[64] = {1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0};

kernel void ecb_kernel(global unsigned char* plainText, global unsigned char* cipherText, global unsigned char* key, global unsigned char* constantValue, global unsigned int* adjacencyList,

                       unsigned int vertexCount, unsigned int vertexEdgeCount, unsigned int blockSize, unsigned int keySize, unsigned int constantSize) {
  size_t globalId = get_global_id(0);
  size_t blockId = get_group_id(0);
  size_t localId = get_local_id(0);
  size_t localSize = get_local_size(0);

  local unsigned char keySchedule[64 * 4];

  local unsigned char left[128], right[128];
  local unsigned char cellValues[230];
  local unsigned char cellValuesNew[230];
  local unsigned char temp[128];

  local unsigned int alCopy[1380];

  if (localId < 230) {
    for (int i = 0; i < 6; ++i)
      alCopy[hook(10, localId + 230 * i)] = adjacencyList[hook(4, localId + 230 * i)];
  }

  if (localId < 128) {
    keySchedule[hook(11, localId)] = key[hook(2, localId)];
  }
  if (localId >= 128 && localId < 192) {
    keySchedule[hook(11, localId)] = key[hook(2, 64 - (localId - 128))];
  }
  if (localId >= 192 && localId < 256) {
    keySchedule[hook(11, localId)] = key[hook(2, 128 - (localId - 192))];
  }

  size_t offset = 0;
  if (localId < 230) {
    offset = localId * vertexEdgeCount;
  }

  if (localId < 128) {
    left[hook(12, localId)] = plainText[hook(0, localId + blockId * kBlockSize)];
  } else {
    right[hook(13, localId - 128)] = plainText[hook(0, localId + blockId * kBlockSize)];
  }

  barrier(0x01);

  unsigned long arg = 0;
  for (size_t roundNumber = 0; roundNumber < 4; ++roundNumber) {
    if (localId < 128) {
      cellValues[hook(14, localId)] = temp[hook(15, localId)] = right[hook(13, localId)];
    }

    if (localId >= 128 && localId < 192) {
      cellValues[hook(14, localId)] = keySchedule[hook(11, roundNumber * (localId - 128))];
    }

    if (localId >= 192 && localId < 230) {
      cellValues[hook(14, localId)] = constantValue[hook(3, localId - 192)];
    }

    barrier(0x01);
    for (size_t it = 0; it < 8; ++it) {
      arg = 0;
      if (localId < vertexEdgeCount) {
        if (it % 2) {
          arg |= cellValuesNew[hook(16, alCopy[lhook(10, localId + offset))] << localId;
        } else {
          arg |= cellValues[hook(14, alCopy[lhook(10, localId + offset))] << localId;
        }
      }

      barrier(0x01);

      if (localId < vertexCount) {
        if (it % 2) {
          cellValues[hook(14, localId)] = localLinkFunction[hook(17, arg)];
        } else {
          cellValuesNew[hook(16, localId)] = localLinkFunction[hook(17, arg)];
        }
      }
      barrier(0x01);
    }

    if (localId < 128) {
      right[hook(13, localId)] = left[hook(12, localId)] ^ cellValues[hook(14, localId)];
      left[hook(12, localId)] = temp[hook(15, localId)];
    }
    barrier(0x01);
  }

  if (localId < 128) {
    cipherText[hook(1, localId + kBlockSize * blockId)] = left[hook(12, localId)];
  } else {
    cipherText[hook(1, localId + kBlockSize * blockId)] = right[hook(13, localId - 128)];
  }
}