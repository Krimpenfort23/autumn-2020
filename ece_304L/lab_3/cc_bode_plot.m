%% Fresh Start
clear all; close all; clc;

%% Init
v_sig = 	[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4];
input_f =	[50,100,150,200,300,500,1e3,3e3,5e3,10e3,100e3,500e3,1e6,2e6,10e6];
v_out =		[303e-3,830e-3,1.66,1.83,2.06,2.13,2.16,2.16,2.19,2.19,2.22,1.16,980e-3,800e-3,536e-3];
v_sig_ = 	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
input_f_ =	[50,100,150,200,300,500,1e3,3e3,5e3,10e3,100e3,500e3,1e6,2e6,10e6];
v_out_ =	[120e-3,500e-3,669e-3,750e-3,920e-3,1.05,1.17,1.22,1.23,1.23,1.28,744e-3,481e-3,278e-3,154e-3];

%% arithmatic
gain =              v_out./v_sig;
max_gain =          max(gain);
half_power_gain =   max_gain/sqrt(2)
gain_ =              v_out_./v_sig_;
max_gain_ =          max(gain_);
half_power_gain_ =   max_gain_/sqrt(2)
%% output
hax = axes;

figure(1);
semilogx(input_f,gain,'rx-');
line(get(hax, 'XLim'),[half_power_gain half_power_gain],'Color',[1 0 1]);
xlabel('Frequency (Hz)');
ylabel('Gain (V/V)');
title('Frequency v. Gain CC Amp');
grid on

figure(2);
semilogx(input_f_,gain_,'rx-');
line(get(hax, 'XLim'),[half_power_gain_ half_power_gain_],'Color',[1 0 1]);
xlabel('Frequency (Hz)');
ylabel('Gain (V/V)');
title('Frequency v. Gain Full Stage');
grid on