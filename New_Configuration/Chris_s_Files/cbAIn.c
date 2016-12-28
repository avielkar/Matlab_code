#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int boardNum, channel, vrange, errorCode;
    unsigned short dataVal;
    float volts;
    
    if (nrhs != 3) {
        mexErrMsgTxt("*** Usage: cbAIn(boardNum, channel, vrange)");
    }
    
    boardNum = (int)mxGetScalar(prhs[0]);
    channel = (int)mxGetScalar(prhs[1]);
    vrange = (int)mxGetScalar(prhs[2]);
    
    // Grab the analog input value.
    errorCode = cbAIn(boardNum, channel, vrange, &dataVal);
    
    // Convert the input value into volts.
    cbToEngUnits(boardNum, vrange, dataVal, &volts);
    
    // Store the return values.
    plhs[0] = mxCreateScalarDouble((double)volts);
    plhs[1] = mxCreateScalarDouble((double)errorCode);
}