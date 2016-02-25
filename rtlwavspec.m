% RTLWAVSPEC.M: An Octave script to read an audio wave file
% and plot a spectrogram from it as a heat map.
% It's set up to work from the commandline in a headless environment,
% but is easily changed if you just want GnuPlot to open a GUI plot
% window instead.
% Copyright 2015-2016 Andrew Thomas.
% Released under GPL2 (see https://github.com/geocomputing/octavertlsdr).

graphics_toolkit("gnuplot");
arglist=argv();
if length(arglist)!=2
  fprintf('ERROR: You must specify an input file name and an output file name.\n\n');
  exit;
end
fname=arglist{1};
imfile=arglist{2};
% Read the wav file into memory
[wave,fs]=wavread(fname);
% Use just the left channel in case it's a stereo wave file
left=wave(:,1);
% The scale factor (0 to 1) adjusts the proportion of the maximum
% amplitude that will be the hottest colour. It can be used to adjust
% sensitivity to smaller signals or to remove the effects of some
% outlier high values on the spectrogram
sf=1;
% The maximum frequency that will be shown on the Y-Axis
maxf=20;
% Create the spectrogram data from the left channel with 2048
% points in the FFT and each FFT overlapping by 1024 data points
[b,f,t]=specgram(left,2048,fs,boxcar(2048),1024);
% Create a figure
h=figure(1);
% Create the spectrogram image and plot it. The frequency is divided
% by 1000 to convert it to kHz.
imagesc(t,f/1000,abs(b));
% Scale the colours (see scale factor above)
caxis([0 sf*max(max(abs(b)))]);
% Set the maximum frequency for the Y-Axis
ylim([0 maxf]);
% Prevent scientific notation on the Y-Axis tick labels
set(gca,'YTickLabel',num2str(get(gca,'YTick')'));
% Make the Y-Axis zero at the bottom of the plot
axis xy;
% Add some labels to the axes
xlabel('Time (seconds)');
ylabel('Frequency (kHz)');
print(h,'-dpng','-color',imfile);
