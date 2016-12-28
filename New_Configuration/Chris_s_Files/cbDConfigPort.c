//***********************************************************************//
//  cbDConfigPort                                                        //
//                                                                       //
//  Configures a digital port for input or output.                       //
//                                                                       //
//  @Author:    Christopher Broussard                                    //
//  @Date:      November, 2005                                           //
//***********************************************************************//
#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int boardNum, portNum, direction, errCode;
    
    if (nrhs != 3) {
        mexErrMsgTxt("*** Usage: [errorCode] = cbDConfigPort(boardNum, portNum, direction)");
    }
    
    boardNum = (int)mxGetScalar(prhs[0]);
    portNum = (int)mxGetScalar(prhs[1]);
    direction = (int)mxGetScalar(prhs[2]);
    
    errCode = cbDConfigPort(boardNum, portNum, direction);
    
    plhs[0] = mxCreateScalarDouble((double)errCode);
}