//***********************************************************************//
//  cbGetErrMsg                                                          //
//                                                                       //
//  Returns the error message associated with an error code.             //
//                                                                       //
//  @Author:    Christopher Broussard                                    //
//  @Date:      November, 2005                                           //
//***********************************************************************//
#include <mex.h>
#include <cbw.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int errorCode;
    char buf[ERRSTRLEN];
    
    if (nrhs != 1) {
        mexErrMsgTxt("*** Usage: [errorString] = cbGetErrMsg(errorCode)");
    }
    
    errorCode = (int)mxGetScalar(prhs[0]);
    
    cbGetErrMsg(errorCode, buf);
    
    plhs[0] = mxCreateString(buf);
}