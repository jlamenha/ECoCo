#!/usr/bin/env python3
"""
Visualization script for SQL query generation evaluation results.
Generates insights from the evaluation_results.csv data.
"""

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from pathlib import Path
from matplotlib.patches import Patch

# Set style
plt.style.use('seaborn-v0_8-whitegrid')
sns.set_palette("husl")

# Load data
csv_path = Path(__file__).parent.parent / "backend/priv/static/csv/evaluation_results.csv"
df = pd.read_csv(csv_path)

# Clean up model names for display
df['model_short'] = df['model'].apply(lambda x: x.split('/')[-1])

# Complexity color mapping (used across figures)
COMPLEXITY_COLORS = {'simple': '#3498db', 'complex': '#e74c3c'}
schema_complexity_map = df.drop_duplicates('schema_name').set_index('schema_name')['complexity']

# Final snapshot per question (confidence_score and other question-level metrics)
last_snap = df.loc[df.groupby('run_id')['num_queries'].idxmax()]
# Final snapshot per model per question (consistency_score and other model-level metrics)
last_snap_model = df.loc[df.groupby(['run_id', 'model'])['num_queries'].idxmax()]

# Create output directory
output_dir = Path(__file__).parent / "figures"
output_dir.mkdir(exist_ok=True)

# ============================================================================
# Figure 1: Average Consistency Score by Model
# ============================================================================
fig, ax = plt.subplots(figsize=(12, 6))
model_consistency = last_snap_model.groupby('model_short')['consistency_score'].mean().sort_values(ascending=True)
colors = sns.color_palette("viridis", len(model_consistency))
bars = ax.barh(model_consistency.index, model_consistency.values, color=colors)
ax.set_xlabel('Average Consistency Score', fontsize=24)
ax.set_title('Average Consistency Score by Model', fontsize=22, fontweight='bold')
ax.tick_params(axis='both', labelsize=20)
ax.set_xlim(0, 1)
for bar, val in zip(bars, model_consistency.values):
    ax.text(val + 0.02, bar.get_y() + bar.get_height()/2, f'{val:.3f}',
            va='center', fontsize=16)
plt.tight_layout()
plt.savefig(output_dir / '1_consistency_by_model.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================================================
# Figure 2: Consistency Score vs Number of Episodes (by Model)
# ============================================================================
progression_csv_path = Path(__file__).parent.parent / "backend/priv/static/csv/consistency_progression.csv"
if progression_csv_path.exists():
    prog_df = pd.read_csv(progression_csv_path)
    prog_df['model_short'] = prog_df['model'].apply(lambda x: x.split('/')[-1])

    fig, ax = plt.subplots(figsize=(3.33, 3.2))
    all_models_fig2 = sorted(prog_df['model_short'].unique())
    palette_fig2 = sns.color_palette("tab10", len(all_models_fig2))
    color_map_fig2 = dict(zip(all_models_fig2, palette_fig2))
    markers = ['o', 's', '^', 'D', 'v', 'P', '*', 'X', 'h', 'p']
    marker_map_fig2 = {m: markers[i % len(markers)] for i, m in enumerate(all_models_fig2)}
    for model in prog_df['model_short'].unique():
        model_data = prog_df[prog_df['model_short'] == model].groupby('checkpoint')['consistency_score'].mean()
        ax.plot(model_data.index, model_data.values,
                marker=marker_map_fig2[model], label=model,
                linewidth=1.0, markersize=4, color=color_map_fig2[model])
    ax.set_xlabel('Number of Episodes', fontsize=8)
    ax.set_ylabel('Average Consistency Score', fontsize=8)
    ax.set_title('How Consistency Varies with Number of Episodes', fontsize=9, fontweight='bold')
    ax.tick_params(axis='both', labelsize=7)
    handles, labels = ax.get_legend_handles_labels()
    sorted_pairs = sorted(zip(labels, handles))
    sorted_labels, sorted_handles = zip(*sorted_pairs)
    ax.legend(sorted_handles, sorted_labels, loc='upper center',
              bbox_to_anchor=(0.5, -0.28), ncol=2, fontsize=6.5, framealpha=0.9)
    ax.set_ylim(0, 1.05)
    plt.tight_layout()
    plt.savefig(output_dir / '2_consistency_vs_num_episodes.png', dpi=300, bbox_inches='tight')
    plt.close()
else:
    print("Warning: consistency_progression.csv not found, skipping Figure 2")

# ============================================================================
# Figure 3: Query Failure Rate by Model
# ============================================================================
n_models = len(df['model_short'].unique())
fig, ax = plt.subplots(figsize=(10, max(4, n_models * 1.2)))
df['failure_rate'] = df['failed_queries'] / (df['successful_queries'] + df['failed_queries'])
failure_by_model = df.groupby('model_short')['failure_rate'].mean().sort_values(ascending=True)
colors = sns.color_palette("RdYlGn_r", len(failure_by_model))
bars = ax.barh(failure_by_model.index, failure_by_model.values * 100, color=colors)
ax.set_xlabel('Average Failure Rate (%)', fontsize=24)
ax.set_title('Query Failure Rate by Model', fontsize=22, fontweight='bold')
ax.tick_params(axis='both', labelsize=20)
max_val = max(failure_by_model.values * 100) if failure_by_model.values.max() > 0 else 5
ax.set_xlim(0, max_val * 1.3 if max_val > 0 else 5)
for bar, val in zip(bars, failure_by_model.values * 100):
    ax.text(val + max_val * 0.02, bar.get_y() + bar.get_height()/2, f'{val:.1f}%',
            va='center', fontsize=16)
plt.tight_layout()
plt.savefig(output_dir / '3_failure_rate_by_model.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================================================
# Figure 4: Confidence Score by Schema (Cross-Model Agreement)
# ============================================================================
fig, ax = plt.subplots(figsize=(3.33, 6.0))
# Use run_id to get one confidence score per run, then group by schema
schema_confidence = last_snap.groupby('schema_name')['confidence_score'].mean().sort_values(ascending=True)
colors = [COMPLEXITY_COLORS.get(schema_complexity_map.get(s, 'simple'), '#888888')
          for s in schema_confidence.index]
def wrap_if_long(name, threshold=14):
    if len(name) <= threshold:
        return name
    parts = name.split('_')
    if len(parts) < 2:
        return name
    mid = len(name) // 2
    pos, best_pos, best_diff = 0, 1, float('inf')
    for i, part in enumerate(parts[:-1]):
        pos += len(part) + 1
        if abs(pos - mid) < best_diff:
            best_diff = abs(pos - mid)
            best_pos = i + 1
    return '_'.join(parts[:best_pos]) + '\n' + '_'.join(parts[best_pos:])

wrapped_labels = [wrap_if_long(s) for s in schema_confidence.index]
bars = ax.barh(range(len(schema_confidence)), schema_confidence.values, color=colors)
ax.set_yticks(range(len(schema_confidence)))
ax.set_yticklabels(wrapped_labels)
ax.set_xlabel('Average Confidence Score', fontsize=8)
ax.set_title('Average Confidence Score by Schema', fontsize=9, fontweight='bold')
ax.tick_params(axis='both', labelsize=6.5)
ax.set_xlim(0, 1.1)
for bar, val in zip(bars, schema_confidence.values):
    ax.text(val + 0.02, bar.get_y() + bar.get_height()/2, f'{val:.2f}',
            va='center', fontsize=5.5)
legend_elements = [Patch(facecolor=COMPLEXITY_COLORS['simple'], label='Simple'),
                   Patch(facecolor=COMPLEXITY_COLORS['complex'], label='Complex')]
ax.legend(handles=legend_elements, loc='upper center',
          bbox_to_anchor=(0.5, -0.06), ncol=2, fontsize=7)
plt.tight_layout()
plt.subplots_adjust(left=0.35, bottom=0.08)
plt.savefig(output_dir / '4_confidence_by_schema.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================================================
# Figure 5: Heatmap - Model Performance by Schema
# ============================================================================
fig, ax = plt.subplots(figsize=(22, 16))
# Order schemas: simple first, then complex (alphabetically within each group)
all_schemas = df['schema_name'].unique()
simple_schemas = sorted([s for s in all_schemas if schema_complexity_map.get(s) == 'simple'])
complex_schemas = sorted([s for s in all_schemas if schema_complexity_map.get(s) == 'complex'])
ordered_schemas = simple_schemas + complex_schemas
pivot_table = last_snap_model.pivot_table(values='consistency_score', index='model_short',
                              columns='schema_name', aggfunc='mean')
pivot_table = pivot_table.reindex(columns=ordered_schemas)
sns.heatmap(pivot_table, annot=True, fmt='.2f', cmap='RdYlGn',
            vmin=0, vmax=1, ax=ax, cbar_kws={'label': 'Consistency Score', 'pad': 0.02},
            annot_kws={'size': 22})
ax.set_title('Model Consistency Score by Schema', fontsize=34, fontweight='bold', pad=12)
ax.set_xlabel('Schema', fontsize=34)
ax.set_ylabel('Model', fontsize=34)
ax.tick_params(axis='both', labelsize=28)
# Color x-axis tick labels by complexity
for tick_label in ax.get_xticklabels():
    schema = tick_label.get_text()
    tick_label.set_color(COMPLEXITY_COLORS.get(schema_complexity_map.get(schema, 'simple'), '#888888'))
    tick_label.set_fontweight('bold')
    tick_label.set_rotation(45)
    tick_label.set_ha('right')
# Add vertical separator between simple and complex groups
if simple_schemas and complex_schemas:
    ax.axvline(x=len(simple_schemas), color='black', linewidth=2, linestyle='--', alpha=0.7)
# Use tight_layout first, then expand bottom margin so the rotated tick labels
# and the figure-level legend both fit without overlapping each other or the colorbar.
plt.tight_layout()
plt.subplots_adjust(bottom=0.35)
# Force a draw so text positions are computed before we query them
fig.canvas.draw()
renderer = fig.canvas.get_renderer()
xlabel_bbox = ax.xaxis.label.get_window_extent(renderer=renderer)
fig_w = fig.get_figwidth() * fig.dpi
fig_h = fig.get_figheight() * fig.dpi
# Position legend: just right of the xlabel, vertically centered on it
leg_x = (xlabel_bbox.x1 + 20) / fig_w
leg_y = (xlabel_bbox.y0 + xlabel_bbox.height / 2) / fig_h
legend_elements = [Patch(facecolor=COMPLEXITY_COLORS['simple'], label='Simple'),
                   Patch(facecolor=COMPLEXITY_COLORS['complex'], label='Complex')]
fig.legend(handles=legend_elements, loc='center left', ncol=2, fontsize=20,
           framealpha=0.9, bbox_to_anchor=(leg_x, leg_y))
plt.savefig(output_dir / '5_heatmap_model_schema.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================================================
# Figure 6: Simple vs Complex Schemas - Model Consistency Comparison
# ============================================================================
if 'complexity' in df.columns:
    simple_by_model = last_snap_model[last_snap_model['complexity'] == 'simple'].groupby('model_short')['consistency_score'].mean()
    complex_by_model = last_snap_model[last_snap_model['complexity'] == 'complex'].groupby('model_short')['consistency_score'].mean()

    # Align models and sort by simple score descending
    all_models = simple_by_model.index.union(complex_by_model.index)
    combined = pd.DataFrame({'Simple': simple_by_model, 'Complex': complex_by_model}).reindex(all_models)
    combined = combined.sort_values('Simple', ascending=False)

    x = np.arange(len(combined))
    bar_width = 0.35

    fig, ax = plt.subplots(figsize=(14, 6))
    bars_simple = ax.bar(x - bar_width / 2, combined['Simple'], bar_width,
                         label='Simple', color=COMPLEXITY_COLORS['simple'])
    bars_complex = ax.bar(x + bar_width / 2, combined['Complex'], bar_width,
                          label='Complex', color=COMPLEXITY_COLORS['complex'])

    for bar in bars_simple:
        val = bar.get_height()
        if not np.isnan(val):
            ax.text(bar.get_x() + bar.get_width() / 2, val + 0.01, f'{val:.2f}',
                    ha='center', va='bottom', fontsize=14)
    for bar in bars_complex:
        val = bar.get_height()
        if not np.isnan(val):
            ax.text(bar.get_x() + bar.get_width() / 2, val + 0.01, f'{val:.2f}',
                    ha='center', va='bottom', fontsize=14)

    ax.set_xticks(x)
    ax.set_xticklabels(combined.index, rotation=45, ha='right', fontsize=16)
    ax.set_ylabel('Average Consistency Score', fontsize=24)
    ax.set_ylim(0, 1.1)
    ax.set_title('Model Consistency: Simple vs Complex Schemas', fontsize=22, fontweight='bold')
    ax.legend(fontsize=20, loc='upper left', bbox_to_anchor=(1.01, 1), borderaxespad=0)
    plt.tight_layout()
    plt.savefig(output_dir / '6_simple_vs_complex.png', dpi=300, bbox_inches='tight')
    plt.close()
else:
    print("Warning: complexity column not found, skipping Figure 6")

# ============================================================================
# Figure 7: Confidence Score Distribution
# ============================================================================
fig, ax = plt.subplots(figsize=(10, 6))
# Get each question's final state (max query snapshot)
unique_evals = last_snap
ax.hist(unique_evals['confidence_score'], bins=20, edgecolor='black', alpha=0.7, color='teal')
ax.axvline(unique_evals['confidence_score'].mean(), color='red', linestyle='--',
           label=f'Mean: {unique_evals["confidence_score"].mean():.3f}')
ax.axvline(unique_evals['confidence_score'].median(), color='orange', linestyle='--',
           label=f'Median: {unique_evals["confidence_score"].median():.3f}')
ax.set_xlabel('Confidence Score', fontsize=24)
ax.set_ylabel('Frequency', fontsize=24)
ax.set_title('Distribution of Confidence Scores Across Questions', fontsize=22, fontweight='bold')
ax.tick_params(axis='both', labelsize=20)
ax.legend(fontsize=20)
plt.tight_layout()
plt.savefig(output_dir / '7_confidence_distribution.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================================================
# Figure 8: Model Ranking Distribution (How often each model produces top result)
# ============================================================================
fig, ax = plt.subplots(figsize=(12, 6))
rank_1_counts = last_snap_model[last_snap_model['model_result_rank'] == 1].groupby('model_short').size()
total_counts = last_snap_model.groupby('model_short').size()
rank_1_percentage = (rank_1_counts / total_counts * 100).sort_values(ascending=True)
colors = sns.color_palette("Greens_d", len(rank_1_percentage))
bars = ax.barh(rank_1_percentage.index, rank_1_percentage.values, color=colors)
ax.set_xlabel('Percentage of Questions with Top-Ranked Result (%)', fontsize=20)
ax.set_title('How Often Each Model Produces the Most Confident Result', fontsize=22, fontweight='bold')
ax.tick_params(axis='both', labelsize=20)
for bar, val in zip(bars, rank_1_percentage.values):
    ax.text(val + 1, bar.get_y() + bar.get_height()/2, f'{val:.1f}%',
            va='center', fontsize=16)
plt.tight_layout()
plt.savefig(output_dir / '8_top_rank_frequency.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================================================
# Figure 9: Ties Analysis - When do models produce tied results?
# ============================================================================
fig, axes = plt.subplots(2, 1, figsize=(12, 18), gridspec_kw={'height_ratios': [1, 2.5]})

# Tie frequency by num_queries
tie_by_queries = df.groupby('num_queries')['is_tied'].mean() * 100
axes[0].bar(tie_by_queries.index.astype(str), tie_by_queries.values, color='purple', alpha=0.7)
axes[0].set_xlabel('Number of Episodes', fontsize=24)
axes[0].set_ylabel('Percentage of Questions with Ties (%)', fontsize=20)
axes[0].set_title('Tie Frequency by Number of Episodes', fontsize=22, fontweight='bold')
axes[0].tick_params(axis='both', labelsize=20)

# Tie frequency by schema, colored by complexity
tie_by_schema = df.groupby('schema_name')['is_tied'].mean().sort_values() * 100
colors_schema = [COMPLEXITY_COLORS.get(schema_complexity_map.get(s, 'simple'), '#888888')
                 for s in tie_by_schema.index]
axes[1].barh(tie_by_schema.index, tie_by_schema.values, color=colors_schema)
axes[1].set_xlabel('Percentage of Questions with Ties (%)', fontsize=20)
axes[1].set_title('Tie Frequency by Schema', fontsize=22, fontweight='bold')
axes[1].tick_params(axis='both', labelsize=20)
legend_elements = [Patch(facecolor=COMPLEXITY_COLORS['simple'], label='Simple'),
                   Patch(facecolor=COMPLEXITY_COLORS['complex'], label='Complex')]
axes[1].legend(handles=legend_elements, loc='lower right', fontsize=20)

plt.suptitle('When Do Models Produce Tied Results?', fontsize=24, fontweight='bold')
plt.tight_layout(rect=[0, 0, 1, 0.97])
plt.savefig(output_dir / '9_ties_analysis.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================================================
# Figure 10: Box Plot - Consistency Score Distribution by Model
# ============================================================================
fig, ax = plt.subplots(figsize=(14, 10))
model_order = last_snap_model.groupby('model_short')['consistency_score'].median().sort_values().index
sns.boxplot(data=last_snap_model, x='model_short', y='consistency_score', order=model_order, ax=ax, palette='Set2')
ax.set_xlabel('Model', fontsize=24)
ax.set_ylabel('Consistency Score', fontsize=24)
ax.set_title('Consistency Score Distribution by Model', fontsize=22, fontweight='bold')
ax.tick_params(axis='both', labelsize=20)
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig(output_dir / '10_consistency_boxplot.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================================================
# Figure 11: Correlation Matrix
# ============================================================================
fig, ax = plt.subplots(figsize=(10, 8))
numeric_cols = ['num_queries', 'consistency_score', 'successful_queries', 'failed_queries',
                'unique_results', 'confidence_score', 'models_contributing',
                'total_unique_confidence_results', 'model_result_rank']
col_labels = {
    'num_queries': 'Number of Episodes',
    'consistency_score': 'Consistency Score',
    'successful_queries': 'Successful Queries',
    'failed_queries': 'Failed Queries',
    'unique_results': 'Unique Results',
    'confidence_score': 'Confidence Score',
    'models_contributing': 'Models Contributing',
    'total_unique_confidence_results': 'Unique Confidence Results',
    'model_result_rank': 'Result Rank',
}
corr_matrix = df[numeric_cols].rename(columns=col_labels).corr()
mask = np.triu(np.ones_like(corr_matrix, dtype=bool))
sns.heatmap(corr_matrix, mask=mask, annot=True, fmt='.2f', cmap='coolwarm',
            center=0, ax=ax, cbar_kws={'label': 'Correlation'}, annot_kws={'size': 16})
ax.set_title('Correlation Matrix of Question Metrics', fontsize=22, fontweight='bold')
ax.tick_params(axis='both', labelsize=20)
plt.xticks(rotation=45, ha='right')
plt.yticks(rotation=0)

# Annotate noteworthy cells with red dotted squares:
# (row, col) pairs in the lower triangle:
#   Successful Queries (2) vs Number of Episodes (0)
#   Consistency Score (1) vs Number of Episodes (0)
#   Confidence Score (5) vs Number of Episodes (0)
#   Confidence Score (5) vs Unique Results (4)
#   Models Contributing (6) vs Confidence Score (5)
highlighted_cells = [(2, 0), (1, 0), (5, 0), (5, 1), (5, 4), (6, 5)]
for (row, col) in highlighted_cells:
    ax.add_patch(plt.Rectangle((col, row), 1, 1, fill=False,
                                edgecolor='red', linewidth=2.5, linestyle='--'))

plt.tight_layout()
plt.savefig(output_dir / '11_correlation_matrix.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================================================
# Figure 12: Consistency on Most Confident Result by Model
# ============================================================================
# For each evaluation, model_result_rank == 1 means that model's most common
# result was also the globally most confident result (agreed upon by all models).
# consistency_score in those rows tells us how reliably the model produced that result.
fig, ax = plt.subplots(figsize=(14, 10))

confident_df = last_snap_model[last_snap_model['model_result_rank'] == 1]
total_runs_per_model = last_snap_model.groupby('model_short')['model_result_rank'].count()
confident_runs_per_model = confident_df.groupby('model_short').size()
alignment_rate = (confident_runs_per_model / total_runs_per_model * 100).fillna(0)

# Weighted score: avg consistency when aligned * alignment rate
avg_consistency_when_confident = confident_df.groupby('model_short')['consistency_score'].mean().sort_values(ascending=True)

colors = sns.color_palette("viridis", len(avg_consistency_when_confident))
bars = ax.barh(avg_consistency_when_confident.index, avg_consistency_when_confident.values, color=colors)
ax.set_xlabel('Average Consistency Score (on Most Confident Result Only)', fontsize=24)
ax.set_title('Model Consistency When Producing the Most Confident Result', fontsize=26, fontweight='bold')
ax.tick_params(axis='both', labelsize=24)
ax.set_xlim(0, 1)

for bar, model, val in zip(bars, avg_consistency_when_confident.index, avg_consistency_when_confident.values):
    rate = alignment_rate.get(model, 0)
    ax.text(val + 0.01, bar.get_y() + bar.get_height() / 2,
            f'{val:.3f}  (aligned {rate:.0f}% of runs)',
            va='center', fontsize=20)

plt.tight_layout()
plt.savefig(output_dir / '12_consistency_on_confident_result.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================================================
# Figure 13: Expected Consistency on Most Confident Answer (alignment rate × consistency)
# ============================================================================
fig, ax = plt.subplots(figsize=(14, 10))

expected_score = (avg_consistency_when_confident * alignment_rate / 100).sort_values(ascending=True)
colors = sns.color_palette("viridis", len(expected_score))
bars = ax.barh(expected_score.index, expected_score.values, color=colors)
ax.set_xlabel('Expected Consistency on Most Confident Answer', fontsize=28)
ax.set_title('Expected Consistency on Most Confident Answer by Model\n(Alignment Rate × Consistency When Aligned)', fontsize=28, fontweight='bold')
ax.tick_params(axis='both', labelsize=24)
ax.set_xlim(0, 1)
for bar, val in zip(bars, expected_score.values):
    ax.text(val + 0.01, bar.get_y() + bar.get_height() / 2, f'{val:.3f}',
            va='center', fontsize=24)
plt.tight_layout()
plt.savefig(output_dir / '13_expected_consistency_on_confident_answers.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================================================
# Summary Statistics
# ============================================================================
print("\n" + "="*60)
print("EVALUATION RESULTS SUMMARY")
print("="*60)

print(f"\nTotal evaluations: {len(df)}")
print(f"Unique questions: {df['question'].nunique()}")
print(f"Schemas tested: {df['schema_name'].nunique()}")
print(f"Models evaluated: {df['model_short'].nunique()}")

print("\n--- Model Performance Summary ---")
model_summary = df.groupby('model_short').agg({
    'consistency_score': ['mean', 'std'],
    'failed_queries': 'sum',
    'successful_queries': 'sum'
}).round(3)
model_summary.columns = ['Avg Consistency', 'Std Consistency', 'Total Failed', 'Total Successful']
model_summary['Success Rate'] = (model_summary['Total Successful'] /
                                  (model_summary['Total Successful'] + model_summary['Total Failed']) * 100).round(1)
print(model_summary.sort_values('Avg Consistency', ascending=False))

print("\n--- Top Performing Model by Schema ---")
for schema in df['schema_name'].unique():
    schema_data = df[df['schema_name'] == schema]
    best_model = schema_data.groupby('model_short')['consistency_score'].mean().idxmax()
    best_score = schema_data.groupby('model_short')['consistency_score'].mean().max()
    print(f"  {schema}: {best_model} ({best_score:.3f})")

print("\n--- Confidence Score Statistics ---")
print(f"  Mean: {unique_evals['confidence_score'].mean():.3f}")
print(f"  Median: {unique_evals['confidence_score'].median():.3f}")
print(f"  Std: {unique_evals['confidence_score'].std():.3f}")
print(f"  Perfect confidence (1.0): {(unique_evals['confidence_score'] == 1.0).sum()} / {len(unique_evals)}")

print(f"\nFigures saved to: {output_dir.absolute()}")
print("="*60)