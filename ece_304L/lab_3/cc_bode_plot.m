## Fresh Start
clear all; close all; clc;

## Init
v_sig = 	(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4);
input_f =	(50,100,150,200,300,500,1k,3k,5k,10k,100k,500k,1M,2M,10M);
v_out =		(303m,830m,1.66,1.83,2.06,2.13,2.16,2.16,2.19,2.19,2.22,1.16,980m,800m,536m);

## arithmatic
gain =		v_out./v_sig;
max_gain =	max(gain);
lower_f =	
mid_f =		
high_f = 	

## output
figure(0);
xlabel('frequency (HZ)');
ylabel('magnitude (V/V)');
title('magnitude v. frequency');
plot(input_f, gain, 'r');