#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int boardNum, functionType, errorCode;
    
    if (nrhs != 2) {
        mexErrMsgTxt("*** Usage: cbStopBackground(boardNum, functionType).");
    }
    
    boardNum = (int)mxGetScalar(prhs[0]);
    functionType = (int)mxGetScalar(prhs[1]);
    
    // Stop the background process.
    errorCode = cbStopBackground(boardNum, functionType);

    plhs[0] = mxCreateScalarDouble((double)errorCode);
}