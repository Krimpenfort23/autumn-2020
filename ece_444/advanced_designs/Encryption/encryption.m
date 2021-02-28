% simple encryption method
clear all; close all; clc;
addr_size = 8;
dat_len = 2^addr_size;

data = uint8(zeros([1 dat_len]) );
enc_data = uint8(zeros([1 dat_len]) );
dec_data = uint8(zeros([1 dat_len]) );
% extract the digits of pi and put into an array
% this is our "data"
%for i=1:dat_len,
%    j = mod(i,14);  % pi to 14 digits
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

% enc_key is our encryption key
enc_key = uint8('ECE501-VHDL-Design');
%encrypt the data
for i=0:dat_len-1,
    j = mod(i,length(enc_key));
    enc_data(i+1) = bitxor(data(i+1),enc_key(j+1));
end
enc_data
%decrypt the data
for i=0:length(enc_data)-1,
    j = mod(i,length(enc_key));
    dec_data(i+1) = bitxor(enc_data(i+1),enc_key(j+1));
end
dec_data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now we generate a .mif file with the encrypted data
fid = fopen('encrypt.mif','w');
fprintf(fid,'WIDTH=%d;\n',uint16(8));
fprintf(fid,'DEPTH=%d;\n\n',uint16(length(enc_data)));
fprintf(fid,'ADDRESS_RADIX=UNS;\nDATA_RADIX=UNS;\n\n');
fprintf(fid,'CONTENT BEGIN\n');
for i = 0:dat_len-1,
    fprintf(fid,'\t%d    :   %d;\n',uint16(i),uint16(enc_data(i+1)));
end
fprintf(fid,'END;\n');
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we can also generate a .csv file for the testbench of decrypt.vhd
fid = fopen('decrypt_input.csv','w');
for i = 1:dat_len,
    fprintf(fid,'%02x,%02x,%02x\n',i-1,enc_data(i),dec_data(i));
end
fclose(fid);
