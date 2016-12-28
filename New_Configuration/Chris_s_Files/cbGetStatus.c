#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int boardNum, functionType, errorCode;
    long curCount, curIndex;
    short status;
    
    if (nrhs != 2) {
        mexErrMsgTxt("*** Usage: cbGetStatus(boardNum, functionType)");
    }
    
    boardNum = (int)mxGetScalar(prhs[0]);
    functionType = (int)mxGetScalar(prhs[1]);;
    
    errorCode = cbGetStatus(boardNum, &status, &curCount, &curIndex, functionType);
    
    // Store the return values.
    plhs[0] = mxCreateScalarDouble((double)status);
    plhs[1] = mxCreateScalarDouble((double)curCount);
    plhs[2] = mxCreateScalarDouble((double)curIndex);
    plhs[3] = mxCreateScalarDouble((double)errorCode);
}