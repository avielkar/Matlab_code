//***********************************************************************//
//  cbGetAInBackgroundScanData                                           //
//                                                                       //
//  Reads the most recent data stored from calling cbAInBackgroundScan().//
//                                                                       //
//  @Author:    Christopher Broussard                                    //
//  @Date:      November, 2005                                           //
//***********************************************************************//
#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int lowChannel, highChannel, memHandle, acqCounts,
        boardNum, i, j, numChans, countsPerChan, vRange;
    double *outData;
    float volts;
    long curCount, curIndex, previousCount, previousIndex, bufferSize;
    short status;
    unsigned short *data;
    
    if (nrhs != 7) {
        mexErrMsgTxt("*** Usage: cbGetAInBackgroundScanData(boardNum, previousCount, previousIndex, bufferSize, [lowChan,highChan], vrange, memHandle");
    }
    
    // Initialize the data pointer.
    data = NULL;
    
    boardNum = (int)mxGetScalar(prhs[0]);
    previousCount = (long)mxGetScalar(prhs[1]);
    previousIndex = (long)mxGetScalar(prhs[2]);
    bufferSize = (long)mxGetScalar(prhs[3]);
    lowChannel = (int)(mxGetPr(prhs[4])[0]);
    highChannel = (int)(mxGetPr(prhs[4])[1]);
    vRange = (int)mxGetScalar(prhs[5]);
    memHandle = (int)mxGetScalar(prhs[6]);
    
    // Channels are supposed to be continuous with no gaps, so this will
    // work to get the number of channels.
    numChans = highChannel - lowChannel + 1;
    
    cbGetStatus(boardNum, &status, &curCount, &curIndex, AIFUNCTION); 
    
    if (status == RUNNING) {
        // Check for a buffer overrun.  If one has occured, stop the
        // background scan and print out an error message.
        if ((curCount - previousCount) > bufferSize) {
            cbStopBackground(boardNum, AIFUNCTION);
            mexErrMsgTxt("*** Buffer overflow!!!");
        }
        
        // Now we extract the data.  Because we have a circular buffer, we
        // must take care to make sure we handle all cases of the buffer index
        // location.
        
        // If the index hasn't wrapped since the last call.
        if ((curIndex - previousIndex) > 0) {
            // Get the total number of new data points to read.  And create
            // an array to hold it all.
            acqCounts = curIndex - previousIndex;
            data = (unsigned short*)mxMalloc(acqCounts*sizeof(unsigned short));
            countsPerChan = acqCounts/numChans;
            
            plhs[0] = mxCreateDoubleMatrix(numChans, countsPerChan, mxREAL);
            outData = mxGetPr(plhs[0]);
         
            // Extract the data from memory.
            cbWinBufToArray(memHandle, data, previousIndex, acqCounts);

            for (i = 0; i < numChans; i++) {
                for (j = 0; j < countsPerChan; j++) {
                    cbToEngUnits(boardNum, vRange, data[j*numChans+i], &volts);
                    outData[j*numChans+i] = (double)volts;
                }
            }
        }
        // If the buffer has wrapped.
        else if ((curIndex - previousIndex) <= 0 && curIndex > -1) {
            // See how many counts have occured since the last call to grab
            // data.
            acqCounts = curCount - previousCount;
            countsPerChan = acqCounts/numChans;
            
            plhs[0] = mxCreateDoubleMatrix(numChans, countsPerChan, mxREAL);
            outData = mxGetPr(plhs[0]);
            
            
            // If acqCounts is zero, then no data has been collected since
            // the last call.
            if (acqCounts > 0) {                
                // Allocate enough memory to hold the data.
                data = (unsigned short*)mxMalloc(acqCounts*sizeof(unsigned short));
                
                // Extract the data from the end of the memory.
                cbWinBufToArray(memHandle, data, previousIndex, bufferSize-previousIndex);
                
                // If there's data at the beginning of memory, grab that too.
                if (curIndex > 0) {
                    // Concatenate with the beginning of the buffer.
                    cbWinBufToArray(memHandle, data+(bufferSize-previousIndex), 0, curIndex);
                }
                
                for (i = 0; i < numChans; i++) {
                    for (j = 0; j < countsPerChan; j++) {
                        cbToEngUnits(boardNum, vRange, data[j*numChans+i], &volts);
                        outData[j*numChans+i] = (double)volts;
                    }
                }
            } // if (acqCounts > 0)
        } // else if ((curIndex - previousIndex) <= 0 && curIndex > -1)
        else {
            plhs[0] = mxCreateDoubleMatrix(0, 0, mxREAL);
        }
    } // if (status == RUNNING)
    else {
        plhs[0] = mxCreateDoubleMatrix(0, 0, mxREAL);
    }
    
    plhs[1] = mxCreateScalarDouble((double)status);
    plhs[2] = mxCreateScalarDouble((double)curCount);
    plhs[3] = mxCreateScalarDouble((double)curIndex);
    
    if (data != NULL) {
        mxFree(data);
    }
}