//***********************************************************************//
//  cbDIn                                                                //
//                                                                       //
//  Reads a digital input port.                                          //
//                                                                       //
//  @Author:    Christopher Broussard                                    //
//  @Date:      September, 2006                                          //
//***********************************************************************//
#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int boardNum, portNum, errCode;
    unsigned short dataVal;
    
    if (nrhs != 2) {
        mexErrMsgTxt("*** Usage: [errorCode] = cbDIn(boardNum, portNum)");
    }
    
    boardNum = (int)mxGetScalar(prhs[0]);
    portNum = (int)mxGetScalar(prhs[1]);
//  value = (unsigned short)mxGetScalar(prhs[2]);
    
    errCode = cbDIn(boardNum, portNum, &dataVal);
    
    plhs[0] = mxCreateScalarDouble((double)dataVal);
	plhs[1] = mxCreateScalarDouble((double)errCode);
}