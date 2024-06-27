% Load the audio file
[file, path] = uigetfile('*.wav', 'Select an audio file');
filePath = fullfile(path, file);
[y, Fs] = audioread(filePath);

% Perform FFT analysis
n = length(y);
f = (0:n-1)*(Fs/n);
Y = fft(y);

% Plot FFT result
figure;
plot(f, abs(Y));
title('FFT of the Audio Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Design bandpass filters
maleFilter = designfilt('bandpassiir', 'FilterOrder', 8, ...
                        'HalfPowerFrequency1', 85, 'HalfPowerFrequency2', 180, ...
                        'SampleRate', Fs);

femaleFilter = designfilt('bandpassiir', 'FilterOrder', 8, ...
                          'HalfPowerFrequency1', 165, 'HalfPowerFrequency2', 255, ...
                          'SampleRate', Fs);

% Filter the signal
maleFiltered = filtfilt(maleFilter, y);
femaleFiltered = filtfilt(femaleFilter, y);

% Calculate the power of the filtered signals
malePower = 10000 * bandpower(maleFiltered); %multiplied by 10^4
femalePower = 10000 * bandpower(femaleFiltered);

% Classify the voice
if malePower > femalePower
    voiceType = 'Male';
else
    voiceType = 'Female';
end

% Display the results
fprintf('Male Power: %.3f\n', malePower(1));
fprintf('Female Power: %.3f\n', femalePower(1));
fprintf('Voice Type: %s\n', voiceType);

% Plot the original and filtered signals
t = (0:length(y)-1)/Fs;
figure;

subplot(2, 1, 1);
plot(t, y);
title('Original Audio Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Determine which filtered signal to use based on voice type
if strcmp(voiceType, 'Male')
    filteredSignal = maleFiltered;
    filterTitle = 'Male Filtered Signal';
else
    filteredSignal = femaleFiltered;
    filterTitle = 'Female Filtered Signal';
end

% Plot the filtered signal
subplot(2, 1, 2);
plot(t, filteredSignal);
title(filterTitle);
xlabel('Time (s)');
ylabel('Amplitude');


