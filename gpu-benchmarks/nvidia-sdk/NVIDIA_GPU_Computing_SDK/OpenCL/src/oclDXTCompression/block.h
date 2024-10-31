





#ifndef BLOCK_H
#define BLOCK_H

#include <oclUtils.h>

union Color32 {
    struct {
        unsigned char b, g, r, a;
    };
    unsigned int u;
};

union Color16 {
    struct {
        unsigned short b : 5;
        unsigned short g : 6;
        unsigned short r : 5;
    };
    unsigned short u;
};

struct BlockDXT1
{
    Color16 col0;
    Color16 col1;
    union {
        unsigned char row[4];
        unsigned int indices;
    };
    
    void decompress(Color32 colors[16]) const;
};

int compareColors(const Color32 * b0, const Color32 * b1);

int compareBlock(const BlockDXT1 * b0, const BlockDXT1 * b1);

#endif 
