

#ifndef PERMUTATIONS_H
#define PERMUTATIONS_H



static void computePermutations(uint permutations[1024])
{
	int indices[16];
	int num = 0;

	

	
	for( int m = 0; m < 16; ++m )
	{
		indices[m] = 0;
	}
	const int imax = 15;
	for( int i = imax; i >= 0; --i )
	{
		
		for( int m = i; m < 16; ++m )
		{
			indices[m] = 2;
		}
		const int jmax = ( i == 0 ) ? 15 : 16;
		for( int j = jmax; j >= i; --j )
		{
			
			if( j < 16 )
			{
				indices[j] = 1;
			}

			uint permutation = 0;
			
			for(int p = 0; p < 16; p++) {
				permutation |= indices[p] << (p * 2);
				
			}
				
			permutations[num] = permutation;
				
			num++;
		}
	}

	for(int i = 0; i < 9; i++)
	{
		permutations[num] = 0x000AA555;
		num++;
	}

	

	
	for( int m = 0; m < 16; ++m )
	{
		indices[m] = 0;
	}
	
	for( int i = imax; i >= 0; --i )
	{
		
		for( int m = i; m < 16; ++m )
		{
			indices[m] = 2;
		}
		const int jmax = ( i == 0 ) ? 15 : 16;
		for( int j = jmax; j >= i; --j )
		{
			
			for( int m = j; m < 16; ++m )
			{
				indices[m] = 3;
			}

			int kmax = ( j == 0 ) ? 15 : 16;
			for( int k = kmax; k >= j; --k )
			{
				
				if( k < 16 )
				{
					indices[k] = 1;
				}
				
				uint permutation = 0;

				bool hasThree = false;
				for(int p = 0; p < 16; p++) {
					permutation |= indices[p] << (p * 2);
					

					if (indices[p] == 3) hasThree = true;
				}
				
				if (hasThree) {
					permutations[num] = permutation;
					num++;
				}
			}
		}
	}
	
	
	
	
	for(int i = 0; i < 49; i++)
	{
		permutations[num] = 0x00AAFF55;
		num++;
	}

}


#endif 
