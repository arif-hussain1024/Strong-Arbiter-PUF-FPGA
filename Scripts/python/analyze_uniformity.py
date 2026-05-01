#!/usr/bin/env python3
"""
PUF Uniformity Analysis Script

Analyzes the uniformity of PUF responses.
Ideal PUF should produce ~50% 0s and ~50% 1s across all challenges.
"""

import numpy as np
import matplotlib.pyplot as plt

def load_multi_puf_data(filename):
    chips = []
    try:
        with open(filename, 'r') as f:
            for line in f:
                if line.startswith('#'): continue
                parts = line.strip().split()
                if len(parts) > 1:
                    responses = [int(r) for r in parts[1:]]
                    if not chips: chips = [[] for _ in range(len(responses))]
                    for i, r in enumerate(responses): chips[i].append(r)
    except FileNotFoundError:
        print(f"ERROR: Could not find {filename}")
        exit(1)
    return chips

def main():
    # PATH FIX: ../../data/
    data_path = '../../data/multi_puf_data.txt'
    results_path = '../../results/uniformity_results.txt'
    plot_path = '../../results/uniformity_plot.png'

    print(f"Loading data from {data_path}...")
    chips = load_multi_puf_data(data_path)
    
    fractions = [sum(c)/len(c) for c in chips]
    avg_uni = np.mean(fractions)
    
    print(f"Average Fraction of 1s: {avg_uni:.4f}")
    
    plt.figure(figsize=(10, 6))
    plt.bar(range(len(chips)), fractions, edgecolor='black')
    plt.axhline(0.5, color='r', linestyle='--', label='Ideal')
    plt.title('Uniformity per Chip')
    plt.savefig(plot_path, dpi=300)
    
    with open(results_path, 'w') as f:
        f.write("PUF UNIFORMITY ANALYSIS RESULTS\n" + "="*60 + "\n")
        f.write(f"Average Fraction of 1s: {avg_uni:.4f}\n")

if __name__ == '__main__':
    main()