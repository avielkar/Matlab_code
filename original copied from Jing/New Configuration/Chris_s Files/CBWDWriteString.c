//***********************************************************************//
//  cbDWriteString                                                       //
//                                                                       //
//  Writes an entire string out to a previous configured digital output  //
//  port.                                                                //
//                                                                       //
//  @Author:    Christopher Broussard                                    //
//  @Date:      November, 2005                                           //
//***********************************************************************//
#include <mex.h>
#include <cbw.h>
#include <time.h>

#define VERBOSE_MODE 0

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int boardNum, portNum, i, bufLen, memHandle, errorCode;
    char *string2write, errString[ERRSTRLEN+256], errBuff[ERRSTRLEN];
    unsigned short *buf, recVal;
    double timeOut;
    clock_t start, finish;
    
    if (nrhs != 3) {
        mexErrMsgTxt("*** Usage: [numBytesWritten] = cbDWriteString(boardNum, stringTowrite, timeOut)");
    }
    
    boardNum = (int)mxGetScalar(prhs[0]);
    string2write = mxArrayToString(prhs[1]);
    timeOut = (double)mxGetScalar(prhs[2]);
    
    bufLen = (int)strlen(string2write);
    
    // Loop through the string passed to this function and send out
    // each byte to the digital port.
    bufLen = (int)strlen(string2write);
    for (i = 0; i < bufLen; i++) {
        // Check to see if receiver is ready.
        start = clock();
        do {
            errorCode = cbDIn(boardNum, SECONDPORTA, &recVal);
            if (errorCode != 0) {
                cbGetErrMsg(errorCode, errBuff);
                sprintf(errString, "*** Error reading receiver bit 1: %s", errBuff);
                mexErrMsgTxt(errString);
            }
            
            if (timeOut > 0) {
                // Make sure that we don't get stuck trying to read the
                // receiver bit.
                finish = clock();
                if ((double)(finish - start)/(double)CLOCKS_PER_SEC > timeOut) {
                    mexErrMsgTxt("*** Receiver bit read timeout 1");
                }
            }
        } while (recVal);
        
        #if VERBOSE_MODE
        mexPrintf("Receiver is ready\n");
        #endif
        
        // Write out the character.
        cbDOut(boardNum, FIRSTPORTA, (unsigned short)string2write[i]);
        
        // Signal that a character has been written.
        if (cbDOut(boardNum, FIRSTPORTB, (unsigned short)1) != 0) {
            mexErrMsgTxt("*** Error writing sender bit 1");
        }
        
        #if VERBOSE_MODE
        mexPrintf("%c written\n", string2write[i]);
        #endif
        
        // Check to make sure the char has been read on the receiver side.
        start = clock();
        do {
            if (cbDIn(boardNum, SECONDPORTA, &recVal) != 0) {
                mexErrMsgTxt("*** Error reading receiver bit 2");
            }
            
            if (timeOut > 0) {
                // Make sure that we don't get stuck trying to read the
                // receiver bit.
                finish = clock();
                if ((double)(finish - start)/(double)CLOCKS_PER_SEC > timeOut) {
                    mexErrMsgTxt("*** Receiver bit read timeout 2");
                }
            }
        } while (!recVal);
        
        #if VERBOSE_MODE
        mexPrintf("char has been read\n");
        #endif
        
        // Reset the sender bit.
        if (cbDOut(boardNum, FIRSTPORTB, (unsigned short)0) != 0) {
            mexErrMsgTxt("*** Error writing sender bit 0");
        }
        
        #if VERBOSE_MODE
        mexPrintf("sent bit reset\n");
        #endif

         cbDOut(boardNum, FIRSTPORTA, 0);
    }
    
   
    // Return the number of bytes written.
    plhs[0] = mxCreateScalarDouble((double)i);
}