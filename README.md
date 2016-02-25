#Octave scripts for use with RTL-SDR dongles

This is a repository of scripts for Octave (and MATLAB with some editing) for use with RTL-SDR software defined radio dongles and Osmocom drivers and software. They've been produced and tested on Linux and so should work without problem on a 'nix box or Raspberry Pi. Most scripts should also work on Windows with very few changes. If you have problems running the scripts, and you're sure the problem is with the script, please check to ensure you've got all of the necessary Octave audio and signal analysis tool boxes installed.

##rtlheatmap.m

rtlheatmap.m is an Octave script to read a time-series measurement file produced using rtl_power and save it as a colourful heatmap graph in an image (PNG) file.

Usage: *octave rtlheatmap.m rtl_power_file.csv heatmap_image_file.png*

##rtlwavspec.m

rtlwavspec.m is an Octave script to read the left channel of an audio wave (WAV) file and generate a spectrogram in the form of a colourful heatmap. In the file you can find a number of parameters that can be adjusted to fine-tune the spectrogram, such as setting the maximum frequency to plot and a scale factor to help find smaller signals. This script is intended for analysis and visualisation of recordings from RTL-SDR software such as rtl_fm.

Usage: *octave rtlwavspecmap.m audio_wave_file.csv spectrogram_image_file.png*

