import SoapySDR
from SoapySDR import *  # SOAPY_SDR_ constants
import numpy as np

# Configuration parameters
sample_rate = 1e6  # Sample rate in Hz
frequency = 915e6  # Frequency in Hz (e.g., 915 MHz for ISM band)
amplitude = 0.5  # Amplitude of sine wave
duration = 5  # Duration of transmission in seconds
num_samples = int(sample_rate * duration)

# Create a sine wave
t = np.arange(num_samples) / sample_rate
waveform = amplitude * np.sin(2 * np.pi * frequency * t)

# Initialize SDR device
sdr = SoapySDR.Device()
sdr.setSampleRate(SOAPY_SDR_TX, 0, sample_rate)
sdr.setFrequency(SOAPY_SDR_TX, 0, frequency)

# Setup a stream (complex floats)
txStream = sdr.setupStream(SOAPY_SDR_TX, "CF32")
sdr.activateStream(txStream)

# Transmit the waveform
sdr.writeStream(txStream, [waveform.astype(np.complex64)], num_samples)

# Stop the stream and close the device
sdr.deactivateStream(txStream)
sdr.closeStream(txStream)
sdr = None

