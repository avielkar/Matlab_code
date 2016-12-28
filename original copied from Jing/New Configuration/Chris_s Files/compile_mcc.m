function compile_mcc(fileName)
    % Make sure that correct number of arguments was given.
    if nargin ~= 1
        error('*** Usage: compile_mcc(fileName)');
        return;
    end
    
    eval(['delete ', fileName(1:end-1), 'ilk ', fileName(1:end-1), 'mexw32 ', fileName(1:end-1), 'pdb']);
    
    outFile = fileName(1:strfind(fileName, '.')-1);
    extraInc = ' -I"C:\MCC\C" ';
    extraLibs = ' cbw32.lib';
    compileString = ['mex -v -output ', outFile, extraInc, fileName, extraLibs];
    %compileString = ['mex -v -D_MSC_VER ', extraLibs, extraInc, fileName];
    eval(compileString);