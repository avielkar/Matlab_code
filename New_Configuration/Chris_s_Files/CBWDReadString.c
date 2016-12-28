//***********************************************************************//
//  cbDReadString                                                        //
//                                                                       //
//  Reads any available characters off of a previously configured        //
//  digital port and returns them as a string.                           //
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
    int boardNum, portNum, i = 0, errorCode, buffSize, buffIncr;
    char *buf;
    unsigned short dataVal, recVal;
    clock_t start, finish;
    double timeOut;
	int PORT4SEND;
	int PORT4SENTIT;
	int PORT4GOTIT;
    
    if (nrhs != 3) {
        mexErrMsgTxt("*** Usage:  [stringVal] = CBWDReadString(boardNum, timeOut, buffSize)");
    }
    
    boardNum = (int)mxGetScalar(prhs[0]);
    timeOut = (double)mxGetScalar(prhs[1]);
    buffSize = (int)mxGetScalar(prhs[2]);


 	PORT4SEND=SECONDPORTB;
	PORT4SENTIT=SECONDPORTCL;
    PORT4GOTIT=FIRSTPORTCL;

    
    // If the buffer gets filled, we'll add buffIncr elements to the buffer.
    buffIncr = buffSize;
    
    buf = (char*)mxMalloc(buffSize*sizeof(char));
    
    // Check to see if we have a string being sent.
    errorCode = cbDIn(boardNum, PORT4SENTIT, &recVal);
    if (recVal) {
        #if VERBOSE_MODE
        mexPrintf("string sent\n");
        #endif
        
        // Loop through and read all data until we get a newline.
        do {
            // Make sure that the server is ready.
            start = clock();
            
            //mexPrintf("start clock\n");
            
            do {
                if (cbDIn(boardNum, PORT4SENTIT, &recVal) != 0) {
                    mexErrMsgTxt("*** Error reading server bit 1");
                }
                
                if (timeOut > 0.0) {
                    // Make sure that we don't get stuck trying to read the
                    // server bit.
                    finish = clock();
                    
                    //mexPrintf("finish-start: %d\n", finish-start);
                    //mexPrintf("%f\n", (double)(finish - start)/(double)CLOCKS_PER_SEC);
                    
                    if ((double)(finish - start)/(double)CLOCKS_PER_SEC > timeOut) {
                        mexErrMsgTxt("*** Server bit read timeout 1");
                    }
                }
            } while (!recVal);
                
            #if VERBOSE_MODE
            mexPrintf("server bit checked\n");
            #endif
            
            // Read the current character
            if (cbDIn(boardNum, PORT4SEND, &dataVal) != 0) {
                mexErrMsgTxt("*** Could not read the character");
            }
            
            // Let the server know we've read in the character.
            if (cbDOut(boardNum, PORT4GOTIT, (unsigned short)1) != 0) {
                mexErrMsgTxt("*** Could not set read bit 1");
            }
            
            #if VERBOSE_MODE
            mexPrintf("%c read, read flag toggled\n", (char)dataVal);
            #endif
            
            // Wait for confirmation that the server knows we've read
            // the bit.
            start = clock();
            do {
                if (cbDIn(boardNum, PORT4SENTIT, &recVal) != 0) {
                    mexErrMsgTxt("*** Error reading server bit 2");
                }
                
                if (timeOut > 0) {
                    // Make sure that we don't get stuck trying to read the
                    // server bit.
                    finish = clock();
                    if ((double)(finish - start)/(double)CLOCKS_PER_SEC > 1.0) {
                        mexErrMsgTxt("*** Server bit read timeout 2");
                    }
                }
            } while (recVal & 1);
            
            #if VERBOSE_MODE
            mexPrintf("server knows we've read\n");
            #endif
            
            // Let the server know that we're ready for another read.
            //if (cbDOut(boardNum, FIRSTPORTA, (unsigned short)0) != 0) {
            if (cbDOut(boardNum, PORT4GOTIT, (unsigned short)0) != 0) {   
                mexErrMsgTxt("*** Could not set read bit 2");
            }
            
            #if VERBOSE_MODE
            mexPrintf("ready for another read\n");
            #endif

            // If it's a newline character, don't bother putting it
            // into the buffer.
            if ((char)dataVal != '\n') {
                // Expand the buffer if it looks like it will get filled
                // completely up.  I always leave at least 1 place for the
                // string terminator character.
                if (i == buffSize-2) {
                    buffSize += buffIncr;
                    buf = (char*)mxRealloc(buf, buffSize*sizeof(char));
                }
                buf[i] = (char)dataVal;
                i++;
            }
        } while ((char)dataVal != '\n');
    }
    
    // Close off the buffer string.
    buf[i] = '\0';
    
    plhs[0] = mxCreateString(buf);
    
    mxFree(buf);
}
