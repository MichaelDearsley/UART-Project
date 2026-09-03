# SystemVerilog UART Transceiver

A from-scratch SystemVerilog UART transceiver designed and verified as a compact RTL project.

The project implements a basic UART transmitter and receiver using an 8N1 protocol, with TX-to-RX loopback and a self-checking simulation environment.

## Features

- SystemVerilog RTL
- UART 8N1 protocol
- UART TX
- UART RX
- Baud-rate timing
- Start-bit detection and validation
- Stop-bit checking
- Framing-error detection
- TX-to-RX loopback
- Self-checking testbench
- GTKWave waveform verification
- Icarus Verilog simulation

## Design Overview

This project implements a basic SystemVerilog UART transceiver using the 8N1 protocol, consisting of a transmitter and receiver. The UART TX accepts an 8-bit parallel byte, adds the required start and stop bits, and uses a baud counter and shift register to transmit the frame serially, least-significant bit first. The UART RX monitors the serial input for a start bit, validates it, samples the eight data bits into a register, checks the stop bit, and outputs the reconstructed byte with an rx_valid signal. The TX and RX are connected in a loopback configuration to verify end-to-end communication, and a self-checking testbench automatically compares transmitted and received data across multiple test cases.

## How to run

Using bash compile and run the simulation using:

```bash
iverilog -g2012 -o loop_tb rtl/uart_tx.sv rtl/uart_rx.sv tb/uart_loopback_tb.sv

vvp loop_tb
```
A successful simulation should produce:
```bash
PASS: Sent 0x41, Received 0x41
PASS: Sent 0x55, Received 0x55
PASS: Sent 0xA5, Received 0xA5
PASS: Sent 0xFF, Received 0xFF
```
To view the generated waveform in GTKWave:
```bash
gtkwave uart_loopback.vcd
```

## Potential future extensions include:

FIFO buffering
More accurate/fractional baud-rate generation
More comprehensive randomized verification
Assertions
Additional UART configuration options
CDC-focused improvements
