#!/usr/bin/env python3
"""
PUF Uniqueness Analysis Script

Analyzes inter-chip variation (uniqueness) across multiple PUF instances.
Metrics calculated:
- Hamming Distance between all chip pairs
- Average inter-chip Hamming Distance
- Uniqueness percentage
"""
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from itertools import combinations

def load_multi_puf_data(filename):
    challenges = []
    chip_responses = []
    try:
        with open(filename, 'r') as f:
            for line in f:
                if line.startswith('#'): continue
                parts = line.strip().split()
                if len(parts) > 1:
                    challenges.append(parts[0])
                    responses = [int(r) for r in parts[1:]]
                    chip_responses.append(responses)
    except FileNotFoundError:
        print(f"ERROR: Could not find data file at {filename}")
        print("Did you move the simulation output to the 'data' folder?")
        exit(1)

    num_chips = len(chip_responses[0])
    chips = [[] for _ in range(num_chips)]
    for response_set in chip_responses:
        for i, resp in enumerate(response_set):
            chips[i].append(resp)
    return challenges, chips

def hamming_distance(resp1, resp2):
    return sum(r1 != r2 for r1, r2 in zip(resp1, resp2))

def calculate_uniqueness(chips):
    num_chips = len(chips)
    num_challenges = len(chips[0])
    hamming_distances = []
    for i, j in combinations(range(num_chips), 2):
        hd = hamming_distance(chips[i], chips[j])
        hamming_distances.append(hd / num_challenges)
    
    return {
        'hamming_distances': hamming_distances,
        'avg_hamming_distance': np.mean(hamming_distances),
        'uniqueness': np.mean(hamming_distances) * 100,
        'num_chips': num_chips, 'num_challenges': num_challenges,
        'min_hd': min(hamming_distances), 'max_hd': max(hamming_distances),
        'std_hd': np.std(hamming_distances)
    }

def create_hamming_matrix(chips):
    num_chips = len(chips)
    matrix = np.zeros((num_chips, num_chips))
    for i in range(num_chips):
        for j in range(num_chips):
            if i != j:
                matrix[i, j] = hamming_distance(chips[i], chips[j]) / len(chips[0])
    return matrix

def plot_uniqueness(results, hd_matrix, output_file):
    fig = plt.figure(figsize=(15, 10))
    gs = fig.add_gridspec(3, 2, hspace=0.3, wspace=0.3)
    
    ax1 = fig.add_subplot(gs[0, :])
    ax1.hist(results['hamming_distances'], bins=50, edgecolor='black', alpha=0.7)
    ax1.axvline(0.5, color='green', linestyle='--', label='Ideal (50%)')
    ax1.set_title('Inter-Chip Hamming Distance Distribution')
    ax1.legend()
    
    ax2 = fig.add_subplot(gs[1, :])
    sns.heatmap(hd_matrix, annot=True, fmt='.3f', cmap='RdYlGn', center=0.5, ax=ax2)
    ax2.set_title('Pairwise Hamming Distance Matrix')
    
    plt.savefig(output_file, dpi=300, bbox_inches='tight')

def main():
    # PATH FIX: ../../data/
    data_path = '../../data/multi_puf_data.txt'
    # PATH FIX: ../../results/
    results_path = '../../results/uniqueness_results.txt'
    plot_path = '../../results/uniqueness_plot.png'

    print(f"Loading data from {data_path}...")
    challenges, chips = load_multi_puf_data(data_path)
    
    results = calculate_uniqueness(chips)
    hd_matrix = create_hamming_matrix(chips)
    
    print(f"Uniqueness: {results['uniqueness']:.4f}%")
    plot_uniqueness(results, hd_matrix, plot_path)
    
    with open(results_path, 'w') as f:
        f.write("PUF UNIQUENESS ANALYSIS RESULTS\n" + "="*60 + "\n")
        f.write(f"Uniqueness: {results['uniqueness']:.4f}%\n")
        f.write(f"Average Hamming Distance: {results['avg_hamming_distance']:.6f}\n")

if __name__ == '__main__':
    main()