% mif-file generator
clear all; close all; clc;

dat_len = 256;
data = uint8(zeros([1 dat_len]) );

% extract the digits of pi and put into an array
% this is our "data"
%for i=1:dat_len,
%    j = mod(i,14); % pi to 14 digits
%    data(i) = floor(pi*10^(j-1))-10*floor(pi*10^(j-2));
%end

% digits of pi...
digits(dat_len+1);
a = vpa(pi);
c = char(a);
% put char array into uint8 array
data(1) = uint8(str2double(c(1)));
for i=2:dat_len,
    data(i) = uint8(str2double(c(i+1)));
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now we generate a .mif file
fid = fopen('pi.mif','w');
fprintf(fid,'WIDTH=');
fprintf(fid,'%d;\n',uint16(8));
fprintf(fid,'DEPTH=%d;\n\n',uint16(length(data)));
fprintf(fid,'ADDRESS_RADIX=UNS;\n');
fprintf(fid,'DATA_RADIX=UNS;\n\n');
fprintf(fid,'CONTENT BEGIN\n');
for i = 0:length(data)-1,
        fprintf(fid,'\t%d    :   %d;\n',uint8(i),uint8(data(i+1)));
end
fprintf(fid,'END;\n');
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
