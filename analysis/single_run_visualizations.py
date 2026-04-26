#!/usr/bin/env python3
"""
Single-run visualization script for SQL query generation evaluation results.
Generates insights from the current_run.csv data (overwritten each evaluation run).
"""

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from pathlib import Path
import sys

# Set style with fallback
try:
    plt.style.use('seaborn-v0_8-whitegrid')
except OSError:
    try:
        plt.style.use('seaborn-whitegrid')
    except OSError:
        pass  # Use default style
sns.set_palette("husl")

# Paths - handle both Docker and local development
# In Docker: script at /analysis, backend at /app
# Locally: script at project_root/analysis, backend at project_root/backend
if Path("/app/priv/static/csv").exists():
    # Docker environment
    csv_path = Path("/app/priv/static/csv/current_run.csv")
    output_dir = Path("/app/priv/static/figures")
else:
    # Local development
    csv_path = Path(__file__).parent.parent / "backend/priv/static/csv/current_run.csv"
    output_dir = Path(__file__).parent.parent / "backend/priv/static/figures"

def main():
    # Check if CSV exists
    if not csv_path.exists():
        print(f"Error: {csv_path} not found. Run an evaluation first.")
        sys.exit(1)

    # Load data
    df = pd.read_csv(csv_path)

    if df.empty:
        print("Error: No data in current_run.csv")
        sys.exit(1)

    # Clean up model names for display
    df['model_short'] = df['model'].apply(lambda x: x.split('/')[-1])

    # Convert is_top_result to boolean (it may be read as string from CSV)
    if df['is_top_result'].dtype == 'object':
        df['is_top_result'] = df['is_top_result'].str.lower() == 'true'

    # Create output directory
    output_dir.mkdir(exist_ok=True)

    # Clear old figures
    for old_fig in output_dir.glob("run_*.png"):
        old_fig.unlink()

    generated_figures = []

    # ============================================================================
    # Figure 1: Model Consistency Comparison
    # ============================================================================
    fig, ax = plt.subplots(figsize=(10, max(4, len(df) * 0.8)))

    model_consistency = df.set_index('model_short')['consistency_score'].sort_values(ascending=True)

    # Color based on consistency score
    colors = ['#e74c3c' if v < 0.5 else '#f39c12' if v < 0.75 else '#27ae60'
              for v in model_consistency.values]

    bars = ax.barh(model_consistency.index, model_consistency.values * 100, color=colors)
    ax.set_xlabel('Consistency Score (%)', fontsize=20)
    ax.set_title('Model Consistency Comparison', fontsize=22, fontweight='bold')
    ax.tick_params(axis='both', labelsize=16)
    ax.set_xlim(0, 105)

    for bar, val in zip(bars, model_consistency.values * 100):
        ax.text(val + 2, bar.get_y() + bar.get_height()/2, f'{val:.1f}%',
                va='center', fontsize=16)

    plt.tight_layout()
    fig_path = output_dir / 'run_1_consistency_comparison.png'
    plt.savefig(fig_path, dpi=150, bbox_inches='tight')
    plt.close()
    generated_figures.append(str(fig_path.name))

    # ============================================================================
    # Figure 2: Query Success Rate
    # ============================================================================
    fig, ax = plt.subplots(figsize=(10, max(4, len(df) * 0.8)))

    models = df['model_short'].values
    successful = df['successful_queries'].values
    failed = df['failed_queries'].values

    y_pos = np.arange(len(models))
    bar_height = 0.35

    bars1 = ax.barh(y_pos - bar_height/2, successful, bar_height, label='Successful', color='#27ae60')
    bars2 = ax.barh(y_pos + bar_height/2, failed, bar_height, label='Failed', color='#e74c3c')

    ax.set_yticks(y_pos)
    ax.set_yticklabels(models, fontsize=16)
    ax.set_xlabel('Number of Queries', fontsize=20)
    ax.set_title('Query Success Rate by Model', fontsize=22, fontweight='bold')
    ax.tick_params(axis='both', labelsize=16)
    ax.legend(loc='lower right', fontsize=16)

    # Add value labels
    for bar in bars1:
        width = bar.get_width()
        if width > 0:
            ax.text(width + 0.1, bar.get_y() + bar.get_height()/2, f'{int(width)}',
                    va='center', fontsize=16)
    for bar in bars2:
        width = bar.get_width()
        if width > 0:
            ax.text(width + 0.1, bar.get_y() + bar.get_height()/2, f'{int(width)}',
                    va='center', fontsize=16)

    plt.tight_layout()
    fig_path = output_dir / 'run_2_success_rate.png'
    plt.savefig(fig_path, dpi=150, bbox_inches='tight')
    plt.close()
    generated_figures.append(str(fig_path.name))

    # ============================================================================
    # Figure 3: Unique Results per Model
    # ============================================================================
    fig, ax = plt.subplots(figsize=(10, max(4, len(df) * 0.8)))

    unique_results = df.set_index('model_short')['unique_results'].sort_values(ascending=True)

    # Color: fewer unique results = more consistent = greener
    max_unique = unique_results.max()
    colors = ['#27ae60' if v == 1 else '#f39c12' if v <= max_unique/2 else '#e74c3c'
              for v in unique_results.values]

    bars = ax.barh(unique_results.index, unique_results.values, color=colors)
    ax.set_xlabel('Number of Unique Results', fontsize=20)
    ax.set_title('Unique Results per Model (Lower = More Consistent)', fontsize=22, fontweight='bold')
    ax.tick_params(axis='both', labelsize=16)

    for bar, val in zip(bars, unique_results.values):
        ax.text(val + 0.1, bar.get_y() + bar.get_height()/2, f'{int(val)}',
                va='center', fontsize=16)

    plt.tight_layout()
    fig_path = output_dir / 'run_3_unique_results.png'
    plt.savefig(fig_path, dpi=150, bbox_inches='tight')
    plt.close()
    generated_figures.append(str(fig_path.name))

    print(f"Generated {len(generated_figures)} figures:")
    for fig_name in generated_figures:
        print(f"  - {fig_name}")
    print(f"\nFigures saved to: {output_dir.absolute()}")

    return generated_figures

if __name__ == "__main__":
    main()
