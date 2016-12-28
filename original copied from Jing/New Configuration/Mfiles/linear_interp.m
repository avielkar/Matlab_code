function [interpolatedData] = linear_interp(data, interp_factor)

    index = 1;


    if ( length(data) > 0 && interp_factor > 0 )
%         interp_len = (data_length-1)*interp_factor + 1; %%not sure about this ...
        interp_len = ( length(data) - 1 )*(interp_factor);
        interpolatedData = zeros(1, interp_len);
        
        
        for i = 1:(length(data) - 1)
            pdiff = data(i + 1) - data(i);
%             pdiff = data(i) - data(i-1);
%             pdiff = diff(data);
            
            interpolatedData(index) = data(i);
            index = index + 1;
            
            for j = 1:(interp_factor - 1)
                
                interpolatedData(index) = pdiff/interp_factor * j + data(i);
                index = index + 1;
                
            end
        end
            
%             
% 		for (i = 1; i < data_length; i++) {
% 			pdiff = data[i] - data[i-1];
% 			
% 			interpolatedData[index++] = data[i-1];
% 			for (j = 0; j < interp_factor - 1; j++) {
% 				interpolatedData[index++] = pdiff/interp_factor*(j + 1) + data[i-1];
% 			}
% 		}
% 		interpolatedData[index] = data[i-1];
% 	}
        
    end 