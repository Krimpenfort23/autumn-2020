% LFSR_18.m

clear all; close all; clc;

% collecting the data from the modelsim simulator
f2 = fopen('LFSR18_output.csv','r');
%data = textscan(f2,'%f');
data = textread('LFSR18_output.csv','%f');
%FPGA_out = data{1};
FPGA_out = data;
fclose(f2);

Hst = hist(FPGA_out,20);

figure; plot(FPGA_out);
xlabel('n'); ylabel('x[n]');
title('LFSR 18 output data');
axis([100 200 0 max(FPGA_out)]);
    
figure; bar(Hst./length(FPGA_out));
xlabel('bin'); ylabel('PMF(x)'); 
title('Histogram of LFSR 18 output data');
