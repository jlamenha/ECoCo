const API_URL = import.meta.env.VITE_API_URL ?? "http://localhost:4000";

export async function pingBackend() {
  const res = await fetch(`${API_URL}/api/health`);
  return res.json();
}

export interface Model {
  id: string;
  name: string;
}

export interface Schema {
  id: string;
  init: string;
  seed: string;
}

export async function listModels(): Promise<Model[]> {
  const res = await fetch(`${API_URL}/api/evaluate/list-models`);
  if (!res.ok) {
    throw new Error('Failed to fetch models');
  }
  return res.json();
}

export async function listSchemas(): Promise<string[]> {
  const res = await fetch(`${API_URL}/api/evaluate/list-schemas`);
  if(!res.ok) {
    throw new Error('Failed to fetch schemas');
  }
  const data = await res.json();
  return data.schemas || [];
}

export async function getSchema(id: string): Promise<Schema> {
  const res = await fetch(`${API_URL}/api/schema/${id}`);
  if(!res.ok) {
    throw new Error('Failed to fetch schema');
  }
  return res.json();
}

export interface EvaluateRequest {
  set_schema?: string;
  custom_schema?: string;
  question: string;
  models: string[];
  num_queries: number;
}

export interface QueryResult {
  columns: string[];
  rows: any[][];
  row_count: number;
}

export interface ConsistencyVectorItem {
  count: number;
  result: QueryResult;
  frequency: number;
}

export interface ModelConsistency {
  unique_results: number;
  all_failed: boolean;
  consistency_vector: ConsistencyVectorItem[];
  failed_queries: number;
  successful_queries: number;
  total_queries: number;
}

export interface ModelResult {
  queries: string[];
  consistency: ModelConsistency;
  model: string;
  results: QueryResult[];
}

export interface ConfidenceScore {
  result: QueryResult;
  confidence_score: number;
  models_contributing: number;
  models_with_result: {
    model: string;
    frequency: number;
  }[];
}

export interface OverallConfidence {
  most_confident_result: ConfidenceScore | null;
  all_confidence_scores: ConfidenceScore[];
  total_models: number;
  unique_results: number;
}

export interface EvaluateResponse {
  confidence: {
    confidence: OverallConfidence;
    models: ModelResult[];
  };
}

export async function evaluate(request: EvaluateRequest): Promise<EvaluateResponse> {
  const res = await fetch(`${API_URL}/api/evaluate`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(request),
  });
  if (!res.ok) {
    throw new Error('Failed to evaluate');
  }
  return res.json();
}

export interface GenerateStatisticsResponse {
  success: boolean;
  figures: string[];
  output?: string;
  error?: string;
}

export async function generateStatistics(evaluationData: EvaluateResponse): Promise<GenerateStatisticsResponse> {
  const res = await fetch(`${API_URL}/api/evaluate/generate-statistics`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(evaluationData),
  });
  if (!res.ok) {
    throw new Error('Failed to generate statistics');
  }
  return res.json();
}

export function getFigureUrl(figureName: string, timestamp?: number): string {
  const ts = timestamp || Date.now();
  return `${API_URL}/figures/${figureName}?t=${ts}`;
}