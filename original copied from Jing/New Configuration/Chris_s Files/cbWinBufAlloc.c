#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    long numPoints;
    int handle;
    
    if (nrhs != 1) {
        mexErrMsgTxt("*** Usage: cbWinBufAlloc(numPoints)");
    }
    
    numPoints = (long)mxGetScalar(prhs[0]);
    handle = cbWinBufAlloc(numPoints);
    
    // Store the return values.
    plhs[0] = mxCreateScalarDouble((double)handle);
}