% Jeff Arata
% 10/26/17

% The goal of this project is to find the unknown system/filter/environment
% negatively affecting the sound of an oboe and get rid of it. Here, the
% unknown system will be some genereated filter with some noise. This
% should be similar to the oboe being transmitted over a distance (adding
% noise) and being played in a room (filtering). 

clear;
clc;
close all;


[clean_oboe, fs] = audioread('oboe.wav');
N = length(clean_oboe);

order = 128;                        % Order of filter
cutoff = 2500;                      % Cutoff frequency of filter
b = fir1(order-1, cutoff/(fs/2));     % Coefficients of generated filter, lowpass
noise = 0.05*randn(N, 1);            % Noise to add to oboe
fuzzy_oboe = filter(b, 1, clean_oboe) + noise;  % Our unknown system x[n]

% Remember that generally with higher order filters, you'll want a smaller
% step size, mu.
mu = .008;                          % LMS step size
%mu = 1;                             % NLMS step size
%h = adaptfilt.lms( order+1, mu );     % The LMS filter, matlab bultin

% My own LMS adaptive filter implementation
[h, my_error, my_y] = adap_nlms( fuzzy_oboe, clean_oboe, mu, order);

%[y, e] = filter(h, 1, fuzzy_oboe);

% Plot the clean oboe, the filtered signal (output), and the error.
figure(1)
subplot(2, 1, 1)
plot([clean_oboe, my_y])
axis([0 9000 -1 1])
title('Inverse System Identification')
ylabel('Amplitude')
xlabel('Sample')
legend('Clean Oboe d[n]', 'Output y[n]')
subplot(2, 1, 2)
%plot(e, 'r')
plot(my_error, 'r')
axis([0 9000 -1 1])
ylabel('Amplitude')
xlabel('Sample')
legend('Error e[n]')
% Plot the Power Spectral Density of the clean oboe, the filtered signal
% (output), and the error.

[PSD_desired, F] = pwelch(clean_oboe, [], [], [], fs);
logPSD_desired = 10*log10(PSD_desired);                    
     
[PSD_output, F] = pwelch(my_y, [], [], [], fs);
logPSD_output = 10*log10(PSD_output); 

%[PSD_error, F] = pwelch(e, [], [], [], fs);
%logPSD_error = 10*log10(PSD_error); 

[PSD_error, F] = pwelch(my_error, [], [], [], fs);
logPSD_error = 10*log10(PSD_error); 


figure(2)
subplot(2, 1, 1)
plot(F, [logPSD_desired, logPSD_output])
axis([0 4500 -100 -10])
title('Power Spectral Density')
ylabel('dB')
xlabel('Frequency (Hz)')
legend('Clean Oboe', 'Output')
subplot(2, 1, 2)
plot(F, logPSD_error, 'r')
axis([0 4500 -100 -10])
ylabel('dB')
xlabel('Frequency (Hz)')
legend('Error')

%{
figure(2)
plot(F, [logPSD_desired, logPSD_output, logPSD_error])
axis([0 4500 -100 -10])
title('Power Spectral Density')
ylabel('dB')
xlabel('Frequency (Hz)')
legend('Clean Oboe', 'Output', 'Error')
%}

% Plot the filter coefficients of our unknown system (before noise) and the
% coefficients of the adaptive lms filter

figure(3)
%stem([b' h.Coefficients'])
stem([b' h])
title('Filter Coefficients')
ylabel('Value')
xlabel('Coefficient Number')
legend('Unknown System', 'Adaptive Filter')

% Playback the clean desired oboe, the filtered output oboe, and the error
fprintf('Playing clean oboe\n')
sound(clean_oboe, fs)
pause(2)
fprintf('Playing fuzzy oboe signal\n')
sound(fuzzy_oboe, fs)
pause(2)
fprintf('Playing filtered oboe\n')
sound(my_y, fs)
pause(2)
fprintf('Playing error signal\n')
%sound(e, fs)
sound(my_error, fs)
