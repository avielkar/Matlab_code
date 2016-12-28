#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int boardNum, count, i, cq, gq, errorCode;
    short *chanArray, *gainArray;
    
    short ca[1] = {0};
    short ga[1] = {1};
    
    if (nrhs != 4) {
        mexErrMsgTxt("*** Usage: cbAIn(boardNum, chanArray, gainArray, numChans");
    }
    
    boardNum = (int)mxGetScalar(prhs[0]);
    count = (int)mxGetScalar(prhs[3]);
    
    // Grab the length of the channel and gain arrays and make sure
    // they're the same.
    cq = mxGetN(prhs[1]);
    gq = mxGetN(prhs[2]);
    if (cq != gq) {
        mexErrMsgTxt("*** chanArray and gainArray must be the same length");
    }

    // Get the channel array data.
    chanArray = (short*)mxMalloc(cq * sizeof(short));
    for (i = 0; i < cq; i++) {
        chanArray[i] = (short)mxGetPr(prhs[1])[i];
    }
    
     // Get the gain array data.
    gainArray = (short*)mxMalloc(gq * sizeof(short));
    for (i = 0; i < gq; i++) {
        gainArray[i] = (short)mxGetPr(prhs[2])[i];
    }
    
    // This function call sets up the queue on the DAQ board.  Setting
    // count to 0 disables the queue.
    errorCode = cbALoadQueue(boardNum, chanArray, gainArray, count);
    
    // Store the return variables.
    plhs[0] = mxCreateScalarDouble((double)errorCode);
    
    mxFree(chanArray);
    mxFree(gainArray);
}