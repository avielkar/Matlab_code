#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int errorCode, memHandle;
    
    if (nrhs != 1) {
        mexErrMsgTxt("*** Usage: cbWinBufFree(memHandle)");
    }
    
    memHandle = (int)mxGetScalar(prhs[0]);
    errorCode = cbWinBufFree(memHandle);
    
    // Store the return values.
    plhs[0] = mxCreateScalarDouble((double)errorCode);
}