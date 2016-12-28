

function [interpData] = DifferenceFunc(M, pole, zero, axis)

    poleTerm = pole*2.0*60.0;
	zeroTerm = zero*2.0*60.0;

    switch  axis
        
        case{'Lateral'}            
            x =  M(7).data;
            min_val = min(x) ;
            x =  x - min_val ;
            ypred = zeros(1, length(x));
            
        case{'Surge'}
            x =  M(8).data;
            min_val = min(x) ;
            x =  x - min_val ;
            ypred = zeros(1, length(x));
            
        case{'Heave'}
            x =  M(9).data;
            min_val = min(x) ;
            x =  x - min_val ;
            ypred = zeros(1, length(x));
              
    end
        

% % Transfer function 
        for j = 2:length(x)           
            ypred(j) = (1/(1+poleTerm)) * (-ypred(j-1)*(1-poleTerm) + x(j)*(1+zeroTerm) + x(j-1)*(1-zeroTerm));    
%             ypred(j) = (1/(1+poleTerm)) * (-ypred(j)*(1-poleTerm) + x(j+1)*(1+zeroTerm) + x(j)*(1-zeroTerm)); 
        end

        ypred = ypred + min_val;

% %         interpolate the data
        tmppred = linear_interp(ypred, 10); 
        interframe_time = 1/60 * 1000; %% in millisec
        pred_len = floor(500/interframe_time*10);
        i_ypred = zeros(1, pred_len + length(tmppred));
        interpData = [];
        
% %note: length(i_ypred) = length(tmppred) + pred_len];
% %note: interp_length = length(tmppred) see NumericalMethods.vcproj
        
% %         Pad the interpolated data
        for i = 1:pred_len - 1  % => for (i = 0; i < pred_len; i++)
            i_ypred(i) = tmppred(1); %set the first 299 pts of the prediected data to a certain value
        end
            
            
        for i = pred_len : ( pred_len + length(tmppred) ) - 1 % => for (i = pred_len; i < pred_len + interp_len; i++)
            i_ypred(i) = tmppred( (i - pred_len) + 1 ); % => i_ypred[i] = tmppred[i-pred_len];
        end
     
        PRED_OFFSET = 475;
        offset = floor(PRED_OFFSET/(1/60*1000) * 10);
        counter_interpData = 1;              
        
        for i = offset:10:(length(tmppred) + pred_len - 1) % => for (i = offset; i < interp_len + pred_len; i += 10)
            interpData(1, counter_interpData) = i_ypred(1, i);
            counter_interpData = counter_interpData + 1;
        end


   