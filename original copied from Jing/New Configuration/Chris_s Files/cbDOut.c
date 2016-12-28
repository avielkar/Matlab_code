//***********************************************************************//
//  cbDOut                                                               //
//                                                                       //
//  Writes a byte to a digital output port.                              //
//                                                                       //
//  @Author:    Christopher Broussard                                    //
//  @Date:      December, 2005                                           //
//***********************************************************************//
#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int boardNum, portNum, errCode;
    unsigned short value;
    
    if (nrhs != 3) {
        mexErrMsgTxt("*** Usage: [errorCode] = cbDOut(boardNum, portNum, value)");
    }
    
    boardNum = (int)mxGetScalar(prhs[0]);
    portNum = (int)mxGetScalar(prhs[1]);
    value = (unsigned short)mxGetScalar(prhs[2]);
    
    errCode = cbDOut(boardNum, portNum, value);
    
    plhs[0] = mxCreateScalarDouble((double)errCode);
}