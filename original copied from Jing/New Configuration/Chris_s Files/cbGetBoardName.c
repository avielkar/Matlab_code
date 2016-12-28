//***********************************************************************//
//  cbGetBoardName                                                       //
//                                                                       //
//  Returns the board name of a specified board.                         //
//                                                                       //
//  @Author:    Christopher Broussard                                    //
//  @Date:      November, 2005                                           //
//***********************************************************************//
#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int boardNum, errorCode;
    char buf[BOARDNAMELEN];
    
    if (nrhs != 1) {
        mexErrMsgTxt("*** Usage: [boardName, errorCode] = cbGetBoardName(boardNum)");
    }
    
    boardNum = (int)mxGetScalar(prhs[0]);
    
    errorCode = cbGetBoardName(boardNum, buf);
    
    plhs[0] = mxCreateString(buf);
    plhs[1] = mxCreateScalarDouble((double)errorCode);
}