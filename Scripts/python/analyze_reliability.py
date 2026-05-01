#!/usr/bin/env python3
"""
PUF Reliability Analysis Script

Analyzes intra-chip variation (reliability) of a single PUF instance.
Metrics calculated:
- Bit Error Rate (BER) for each challenge
- Average BER across all challenges
- Reliability percentage
"""

import numpy as np
import matplotlib.pyplot as plt
from collections import defaultdict

def load_single_puf_data(filename):
    challenges, responses, test_numbers = [], [], []
    try:
        with open(filename, 'r') as f:
            for line in f:
                if line.startswith('#'): continue
                parts = line.strip().split()
                if len(parts) == 3:
                    challenges.append(parts[0])
                    responses.append(int(parts[1]))
                    test_numbers.append(int(parts[2]))
    except FileNotFoundError:
        print(f"ERROR: Could not find {filename}")
        exit(1)
    return challenges, responses, test_numbers

def calculate_reliability(challenges, responses, test_numbers):
    challenge_responses = defaultdict(list)
    for c, r, t in zip(challenges, responses, test_numbers):
        challenge_responses[c].append(r)
    
    bers = []
    for resps in challenge_responses.values():
        ref = max(set(resps), key=resps.count)
        errors = sum(1 for r in resps if r != ref)
        bers.append(errors / len(resps))
    
    avg_ber = np.mean(bers)
    return {'bers': bers, 'avg_ber': avg_ber, 'reliability': (1 - avg_ber) * 100}

def plot_reliability(results, output_file):
    plt.figure(figsize=(10, 6))
    plt.hist(results['bers'], bins=50, edgecolor='black', alpha=0.7)
    plt.title('Distribution of Bit Error Rates (BER)')
    plt.axvline(results['avg_ber'], color='red', linestyle='--', label=f"Avg: {results['avg_ber']:.4f}")
    plt.legend()
    plt.savefig(output_file, dpi=300)

def main():
    # PATH FIX: ../../data/
    data_path = '../../data/single_puf_data.txt'
    results_path = '../../results/reliability_results.txt'
    plot_path = '../../results/reliability_plot.png'

    print(f"Loading data from {data_path}...")
    c, r, t = load_single_puf_data(data_path)
    
    results = calculate_reliability(c, r, t)
    
    print(f"Reliability: {results['reliability']:.4f}%")
    plot_reliability(results, plot_path)
    
    with open(results_path, 'w') as f:
        f.write("PUF RELIABILITY ANALYSIS RESULTS\n" + "="*60 + "\n")
        f.write(f"Reliability: {results['reliability']:.4f}%\n")
        f.write(f"Average BER: {results['avg_ber']:.6f}\n")

if __name__ == '__main__':
    main()