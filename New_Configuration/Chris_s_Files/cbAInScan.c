#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int boardNum, lowChannel, highChannel, vrange, errorCode, memHandle, i;
    long sampleRate, sampleCount;
    unsigned short *dataArray;
    mxArray *data;
    double *pData;
    float volts;
    
    if (nrhs != 6) {
        mexErrMsgTxt("*** Usage: cbAInScan(boardNum, [lowChan, highChan], sampleCount, sampleRate, vrange, memHandle");
    }
    
    boardNum = (int)mxGetScalar(prhs[0]);
    lowChannel = (int)(mxGetPr(prhs[1])[0]);
    highChannel = (int)(mxGetPr(prhs[1])[1]);
    sampleCount = (long)mxGetScalar(prhs[2]);
    sampleRate = (long)mxGetScalar(prhs[3]);
    vrange = (int)mxGetScalar(prhs[4]);
    memHandle = (int)mxGetScalar(prhs[5]);
    
    // Scan the analog channels.
    errorCode = cbAInScan(boardNum, lowChannel, highChannel, sampleCount,
                          &sampleRate, vrange, memHandle, 0);
    
    // Store the data from the memory buffer into an array to pass back
    // to Matlab.
    data = mxCreateDoubleMatrix(1, sampleCount, mxREAL);
    pData = mxGetPr(data);
    dataArray = (unsigned short*)memHandle;
    for (i = 0; i < sampleCount; i++) {
        // Convert the data value into volts.
        cbToEngUnits(boardNum, vrange, dataArray[i], &volts);
        
        pData[i] = (double)volts;
    }
    
    // Store the return values.
    plhs[0] = data;
    plhs[1] = mxCreateScalarDouble((double)sampleRate);
    plhs[2] = mxCreateScalarDouble((double)errorCode);
}