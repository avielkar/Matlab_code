#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int boardNum, lowChannel, highChannel, vrange, errorCode, memHandle;
    long sampleRate, sampleCount;
    
    if (nrhs != 6) {
        mexErrMsgTxt("*** Usage: cbAInBackgroundScan(boardNum, [lowChan, highChan], bufferSize, sampleRate, vrange, memHandle)");
    }
    
    boardNum = (int)mxGetScalar(prhs[0]);
    lowChannel = (int)(mxGetPr(prhs[1])[0]);
    highChannel = (int)(mxGetPr(prhs[1])[1]);
    sampleCount = (long)mxGetScalar(prhs[2]);
    sampleRate = (long)mxGetScalar(prhs[3]);
    vrange = (int)mxGetScalar(prhs[4]);
    memHandle = (int)mxGetScalar(prhs[5]);
    
    // Start continually scanning the channels.  This will run in the background
    // until we externally force it to stop.
    errorCode = cbAInScan(boardNum, lowChannel, highChannel, sampleCount,
                          &sampleRate, vrange, memHandle, BACKGROUND | CONTINUOUS);
    
    // Store the return values.
    plhs[0] = mxCreateScalarDouble((double)sampleRate);
    plhs[1] = mxCreateScalarDouble((double)errorCode);
}