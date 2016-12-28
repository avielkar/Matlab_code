#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int boardNum, channel, vrange, errorCode;
    unsigned short dataVal;
    float volts;
    
    if (nrhs != 4) {
        mexErrMsgTxt("*** Usage: cbAOut(boardNum, channel, vrange, volts)");
    }
    
    boardNum = (int)mxGetScalar(prhs[0]);
    channel = (int)mxGetScalar(prhs[1]);
    vrange = (int)mxGetScalar(prhs[2]);
    volts = (float)mxGetScalar(prhs[3]);
    
    // Converts the voltage givent to a D/A count value.
    cbFromEngUnits(boardNum, vrange, volts, &dataVal);
    
    // Now ouput the D/A count value on the card.
    errorCode = cbAOut(boardNum, channel, vrange, dataVal);
    
    // Store the return values.
    plhs[0] = mxCreateScalarDouble((double)dataVal);
    plhs[1] = mxCreateScalarDouble((double)errorCode);
}