#!/usr/bin/env python3
"""
Comprehensive PUF Analysis Script

Runs all PUF analyses and generates a comprehensive report.
"""

import os
import sys
import subprocess
from datetime import datetime

def run_script(script_name):
    print(f"\n{'='*60}")
    print(f"Running {script_name}...")
    print('='*60)
    # python executable ensures we use the same environment
    result = subprocess.run([sys.executable, script_name], capture_output=True, text=True)
    if result.returncode == 0:
        print(result.stdout)
        return True
    else:
        print(f"Error running {script_name}:")
        print(result.stderr)
        return False

def generate_summary_report():
    # PATH FIX: Go up 2 levels to find 'results'
    report_file = '../../results/comprehensive_report.txt'
    
    with open(report_file, 'w') as f:
        f.write("=" * 80 + "\n")
        f.write("COMPREHENSIVE PUF EVALUATION REPORT\n")
        f.write("=" * 80 + "\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        
        result_files = [
            ('RELIABILITY ANALYSIS', '../../results/reliability_results.txt'),
            ('UNIQUENESS ANALYSIS', '../../results/uniqueness_results.txt'),
            ('UNIFORMITY ANALYSIS', '../../results/uniformity_results.txt')
        ]
        
        for title, filename in result_files:
            if os.path.exists(filename):
                f.write("\n" + "=" * 80 + "\n")
                f.write(f"{title}\n")
                f.write("=" * 80 + "\n")
                with open(filename, 'r') as rf:
                    # FIX: Changed from [3:] to [2:] so we don't delete the data!
                    lines = rf.readlines()[2:] 
                    f.writelines(lines)
    print(f"\nComprehensive report saved to {report_file}")

def main():
    print("=" * 80)
    print("COMPREHENSIVE PUF ANALYSIS SUITE")
    print("=" * 80)
    
    # Ensure results directory exists
    os.makedirs('../../results', exist_ok=True)
    
    scripts = ['analyze_reliability.py', 'analyze_uniqueness.py', 'analyze_uniformity.py']
    
    success_count = 0
    for script in scripts:
        if run_script(script):
            success_count += 1
            
    if success_count == len(scripts):
        generate_summary_report()
        print("\nALL ANALYSES COMPLETE! Check the 'results' folder.")
    else:
        print("\nSome analyses failed. Check the errors above.")

if __name__ == '__main__':
    main()