





__kernel void ckMedian(__global uchar4* uc4Source, __global unsigned int* uiDest,
                       __local uchar4* uc4LocalData, int iLocalPixPitch, 
                       int iImageWidth, int iDevImageHeight
                       )
{
    
    int iImagePosX = get_global_id(0);
    int iDevYPrime = get_global_id(1) - 1;  
    int iDevGMEMOffset = mul24(iDevYPrime, (int)get_global_size(0)) + iImagePosX; 

    
    int iLocalPixOffset = mul24((int)get_local_id(1), iLocalPixPitch) + get_local_id(0) + 1;

    
    if((iDevYPrime > -1) && (iDevYPrime < iDevImageHeight) && (iImagePosX < iImageWidth))
    {
        uc4LocalData[iLocalPixOffset] = uc4Source[iDevGMEMOffset];
    }
    else 
    {
        uc4LocalData[iLocalPixOffset] = (uchar4)0; 
    }

    
    if (get_local_id(1) < 2)
    {
        
        
        iLocalPixOffset += mul24((int)get_local_size(1), iLocalPixPitch);

        
        if (((iDevYPrime + get_local_size(1)) < iDevImageHeight) && (iImagePosX < iImageWidth))
        {
            
            uc4LocalData[iLocalPixOffset] = uc4Source[iDevGMEMOffset + mul24(get_local_size(1), get_global_size(0))];
        }
        else 
        {
            uc4LocalData[iLocalPixOffset] = (uchar4)0; 
        }
    }

    
    if (get_local_id(0) == (get_local_size(0) - 1))
    {
        
        iLocalPixOffset = mul24((int)get_local_id(1), iLocalPixPitch);

        
        if ((iDevYPrime > -1) && (iDevYPrime < iDevImageHeight) && (get_group_id(0) > 0))
        {
            
            uc4LocalData[iLocalPixOffset] = uc4Source[mul24(iDevYPrime, (int)get_global_size(0)) + mul24(get_group_id(0), get_local_size(0)) - 1];
        }
        else 
        {
            uc4LocalData[iLocalPixOffset] = (uchar4)0; 
        }

        
        if (get_local_id(1) < 2)
        {
            
            
            iLocalPixOffset += mul24((int)get_local_size(1), iLocalPixPitch);

            
            if (((iDevYPrime + get_local_size(1)) < iDevImageHeight) && (get_group_id(0) > 0))
            {
                
                uc4LocalData[iLocalPixOffset] = uc4Source[mul24((iDevYPrime + (int)get_local_size(1)), (int)get_global_size(0)) + mul24(get_group_id(0), get_local_size(0)) - 1];
            }
            else 
            {
                uc4LocalData[iLocalPixOffset] = (uchar4)0; 
            }
        }
    } 
    else if (get_local_id(0) == 0) 
    {
        
        iLocalPixOffset = mul24(((int)get_local_id(1) + 1), iLocalPixPitch) - 1;

        if ((iDevYPrime > -1) && (iDevYPrime < iDevImageHeight) && (mul24(((int)get_group_id(0) + 1), (int)get_local_size(0)) < iImageWidth))
        {
            
            uc4LocalData[iLocalPixOffset] = uc4Source[mul24(iDevYPrime, (int)get_global_size(0)) + mul24((get_group_id(0) + 1), get_local_size(0))];
        }
        else 
        {
            uc4LocalData[iLocalPixOffset] = (uchar4)0; 
        }

        
        if (get_local_id(1) < 2)
        {
            
            iLocalPixOffset += (mul24((int)get_local_size(1), iLocalPixPitch));

            if (((iDevYPrime + get_local_size(1)) < iDevImageHeight) && (mul24((get_group_id(0) + 1), get_local_size(0)) < iImageWidth) )
            {
                
                uc4LocalData[iLocalPixOffset] = uc4Source[mul24((iDevYPrime + (int)get_local_size(1)), (int)get_global_size(0)) + mul24((get_group_id(0) + 1), get_local_size(0))];
            }
            else 
            {
                uc4LocalData[iLocalPixOffset] = (uchar4)0; 
            }
        }
    }

    
    barrier(CLK_LOCAL_MEM_FENCE);

    
	
    float fMedianEstimate[3] = {128.0f, 128.0f, 128.0f};
    float fMinBound[3] = {0.0f, 0.0f, 0.0f};
    float fMaxBound[3] = {255.0f, 255.0f, 255.0f};

	
	for(int iSearch = 0; iSearch < 8; iSearch++)  
	{
        uint uiHighCount [3] = {0, 0, 0};
		
        
        iLocalPixOffset = mul24((int)get_local_id(1), iLocalPixPitch) + get_local_id(0);

		
		uiHighCount[0] += (fMedianEstimate[0] < uc4LocalData[iLocalPixOffset].x);					
		uiHighCount[1] += (fMedianEstimate[1] < uc4LocalData[iLocalPixOffset].y);					
		uiHighCount[2] += (fMedianEstimate[2] < uc4LocalData[iLocalPixOffset++].z);					

		
		uiHighCount[0] += (fMedianEstimate[0] < uc4LocalData[iLocalPixOffset].x);					
		uiHighCount[1] += (fMedianEstimate[1] < uc4LocalData[iLocalPixOffset].y);					
		uiHighCount[2] += (fMedianEstimate[2] < uc4LocalData[iLocalPixOffset++].z);					

		
		uiHighCount[0] += (fMedianEstimate[0] < uc4LocalData[iLocalPixOffset].x);					
		uiHighCount[1] += (fMedianEstimate[1] < uc4LocalData[iLocalPixOffset].y);					
		uiHighCount[2] += (fMedianEstimate[2] < uc4LocalData[iLocalPixOffset].z);					

		
		iLocalPixOffset += (iLocalPixPitch - 2);	

		
		uiHighCount[0] += (fMedianEstimate[0] < uc4LocalData[iLocalPixOffset].x);					
		uiHighCount[1] += (fMedianEstimate[1] < uc4LocalData[iLocalPixOffset].y);					
		uiHighCount[2] += (fMedianEstimate[2] < uc4LocalData[iLocalPixOffset++].z);					

		
		uiHighCount[0] += (fMedianEstimate[0] < uc4LocalData[iLocalPixOffset].x);					
		uiHighCount[1] += (fMedianEstimate[1] < uc4LocalData[iLocalPixOffset].y);					
		uiHighCount[2] += (fMedianEstimate[2] < uc4LocalData[iLocalPixOffset++].z);					

		
		uiHighCount[0] += (fMedianEstimate[0] < uc4LocalData[iLocalPixOffset].x);					
		uiHighCount[1] += (fMedianEstimate[1] < uc4LocalData[iLocalPixOffset].y);					
		uiHighCount[2] += (fMedianEstimate[2] < uc4LocalData[iLocalPixOffset].z);					

		
		iLocalPixOffset += (iLocalPixPitch - 2);	

		
		uiHighCount[0] += (fMedianEstimate[0] < uc4LocalData[iLocalPixOffset].x);					
		uiHighCount[1] += (fMedianEstimate[1] < uc4LocalData[iLocalPixOffset].y);					
		uiHighCount[2] += (fMedianEstimate[2] < uc4LocalData[iLocalPixOffset++].z);					

		
		uiHighCount[0] += (fMedianEstimate[0] < uc4LocalData[iLocalPixOffset].x);					
		uiHighCount[1] += (fMedianEstimate[1] < uc4LocalData[iLocalPixOffset].y);					
		uiHighCount[2] += (fMedianEstimate[2] < uc4LocalData[iLocalPixOffset++].z);					

		
		uiHighCount[0] += (fMedianEstimate[0] < uc4LocalData[iLocalPixOffset].x);					
		uiHighCount[1] += (fMedianEstimate[1] < uc4LocalData[iLocalPixOffset].y);					
		uiHighCount[2] += (fMedianEstimate[2] < uc4LocalData[iLocalPixOffset].z);					

		
		
		if(uiHighCount[0] > 4)
		{
			fMinBound[0] = fMedianEstimate[0];				
		}
		else
		{
			fMaxBound[0] = fMedianEstimate[0];				
		}

		if(uiHighCount[1] > 4)
		{
			fMinBound[1] = fMedianEstimate[1];				
		}
		else
		{
			fMaxBound[1] = fMedianEstimate[1];				
		}

		if(uiHighCount[2] > 4)
		{
			fMinBound[2] = fMedianEstimate[2];				
		}
		else
		{
			fMaxBound[2] = fMedianEstimate[2];				
		}

		
		fMedianEstimate[0] = 0.5f * (fMaxBound[0] + fMinBound[0]);
		fMedianEstimate[1] = 0.5f * (fMaxBound[1] + fMinBound[1]);
		fMedianEstimate[2] = 0.5f * (fMaxBound[2] + fMinBound[2]);
	}

    
    unsigned int uiPackedPix = 0x000000FF & (unsigned int)(fMedianEstimate[0] + 0.5f);
    uiPackedPix |= 0x0000FF00 & (((unsigned int)(fMedianEstimate[1] + 0.5f)) << 8);
    uiPackedPix |= 0x00FF0000 & (((unsigned int)(fMedianEstimate[2] + 0.5f)) << 16);

    
    if((iDevYPrime < iDevImageHeight) && (iImagePosX < iImageWidth))
    {
        uiDest[iDevGMEMOffset + get_global_size(0)] = uiPackedPix;
    }
}
