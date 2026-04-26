import { Link } from "react-router-dom";
import { useState, useEffect } from "react";
import { listModels, listSchemas, getSchema, evaluate, generateStatistics, getFigureUrl } from "../api";
import type { Model, EvaluateResponse } from "../api";
import CodeEditor from "../components/CodeEditor";

export default function Evaluate() {
  const [availableModels, setAvailableModels] = useState<Model[]>([]);
  const [selectedModels, setSelectedModels] = useState<string[]>([]);
  const [showModelDropdown, setShowModelDropdown] = useState(false);
  const [modelSearchQuery, setModelSearchQuery] = useState("");
  const [numberOfQueries, setNumberOfQueries] = useState(5);
  const [useOwnData, setUseOwnData] = useState(true);
  const [ddl, setDdl] = useState("");
  const [seedingData, setSeedingData] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [question, setQuestion] = useState("");

  // Schema-related state
  const [availableSchemas, setAvailableSchemas] = useState<string[]>([]);
  const [selectedSchema, setSelectedSchema] = useState<string>("");
  const [loadingSchemas, setLoadingSchemas] = useState(false);

  // Evaluation state
  const [evaluating, setEvaluating] = useState(false);
  const [results, setResults] = useState<EvaluateResponse | null>(null);
  const [selectedQuery, setSelectedQuery] = useState<{
    model: string;
    index: number;
    query: string;
    result: any;
  } | null>(null);

  // Statistics state
  const [showStatistics, setShowStatistics] = useState(false);
  const [statisticsFigures, setStatisticsFigures] = useState<string[]>([]);
  const [generatingStats, setGeneratingStats] = useState(false);
  const [statsError, setStatsError] = useState<string | null>(null);
  const [statsTimestamp, setStatsTimestamp] = useState<number>(0);

  useEffect(() => {
    listModels()
      .then((models) => {
        setAvailableModels(models);
        setLoading(false);
      })
      .catch((err) => {
        setError(err.message);
        setLoading(false);
      });
  }, []);

  useEffect(() => {
    if (!useOwnData) {
      setLoadingSchemas(true);
      listSchemas()
        .then((schemas) => {
          setAvailableSchemas(schemas);
          setLoadingSchemas(false);
        })
        .catch((err) => {
          setError(err.message);
          setLoadingSchemas(false);
        });
    } else {
      setSelectedSchema("");
      setAvailableSchemas([]);
    }
  }, [useOwnData]);

  useEffect(() => {
    if (selectedSchema) {
      getSchema(selectedSchema)
        .then((schemaData) => {
          setDdl(schemaData.init || "");
          setSeedingData(schemaData.seed || "");
        })
        .catch((err) => {
          setError(err.message);
        });
    }
  }, [selectedSchema]);

  const handleAddModel = (modelId: string) => {
    if (!selectedModels.includes(modelId)) {
      setSelectedModels([...selectedModels, modelId]);
    }
    setShowModelDropdown(false);
    setModelSearchQuery("");
  };

  const handleRemoveModel = (modelId: string) => {
    setSelectedModels(selectedModels.filter((id) => id !== modelId));
  };

  const getModelName = (modelId: string) => {
    return availableModels.find((m) => m.id === modelId)?.name || modelId;
  };

  const filteredModels = availableModels.filter((model) => {
    const searchLower = modelSearchQuery.toLowerCase();
    return (
      model.name.toLowerCase().includes(searchLower) ||
      model.id.toLowerCase().includes(searchLower)
    );
  });

  const handleShowStatistics = async () => {
    if (!results) {
      setStatsError("No evaluation results available");
      return;
    }

    setGeneratingStats(true);
    setStatsError(null);

    try {
      const response = await generateStatistics(results);
      if (response.success) {
        setStatisticsFigures(response.figures);
        setStatsTimestamp(Date.now());
        setShowStatistics(true);
      } else {
        setStatsError(response.error || "Failed to generate statistics");
      }
    } catch (err: any) {
      setStatsError(err.message || "Failed to generate statistics");
    } finally {
      setGeneratingStats(false);
    }
  };

  const handleEvaluate = async () => {
    if (selectedModels.length === 0) {
      alert("Please select at least one model");
      return;
    }
    if (!question.trim()) {
      alert("Please enter a question");
      return;
    }
    if (!useOwnData && !selectedSchema) {
      alert("Please select a schema");
      return;
    }
    if (useOwnData && !ddl.trim()) {
      alert("Please enter your database schema");
      return;
    }

    setError(null);
    setEvaluating(true);
    setResults(null);

    try {
      const request: any = {
        question,
        models: selectedModels,
        num_queries: numberOfQueries,
      };

      if (useOwnData) {
        request.custom_schema = ddl;
      } else {
        request.set_schema = selectedSchema;
      }

      const response = await evaluate(request);
      setResults(response);
    } catch (err: any) {
      alert(err.message || "Failed to evaluate");
    } finally {
      setEvaluating(false);
    }
  };

  return (
    <div className="min-h-screen flex flex-col bg-ecoco-mid" style={{ fontFamily: "'DM Sans', sans-serif" }}>
      {/* Navigation */}
      <nav className="flex items-center justify-between px-6 py-4 bg-ecoco-light border-b border-ecoco-mid">
        <a href="/" className="flex items-center gap-2 no-underline">
          <svg viewBox="0 0 100 110" width="28" height="31" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect x="46" y="4" width="8" height="16" rx="4" fill="#2a6632" />
            <path d="M50 14 Q68 4 84 14 Q72 20 56 18 Q53 16 50 14Z" fill="#2a6632" />
            <ellipse cx="50" cy="56" rx="40" ry="36" fill="#2a6632" />
            <text x="50" y="53" textAnchor="middle" dominantBaseline="central"
              fontFamily="Syne, sans-serif" fontWeight="800" fontSize="56"
              textLength="40" lengthAdjust="spacingAndGlyphs"
              fill="#f0f7ee">e</text>
          </svg>
          <span style={{ fontFamily: "'Syne', sans-serif", fontWeight: 800, fontSize: 18, letterSpacing: '-0.03em', color: '#2a6632', lineHeight: 1 }}>
            ECoCo
          </span>
        </a>
        <div className="flex gap-6">
          <Link to="/" className="text-sm font-medium text-ecoco-dark hover:underline">Home</Link>
          <Link to="/evaluate" className="text-sm font-medium text-ecoco-dark hover:underline">Evaluate</Link>
        </div>
      </nav>

      {/* Main Content */}
      <main className="flex-1 px-4 py-6">
        <div className="max-w-5xl mx-auto">
          <h1 className="text-2xl font-bold text-center mb-6 text-ecoco-black" style={{ fontFamily: "'Syne', sans-serif" }}>Evaluate</h1>

          {loading && <div className="text-center text-gray-600 mb-4 text-sm">Loading models...</div>}
          {error && <div className="text-center text-red-600 mb-4 text-sm">Error: {error}</div>}

          {/* Selected Model Cards */}
          <div className="space-y-2 mb-4">
            {selectedModels.map((modelId) => (
              <div key={modelId} className="bg-white px-4 py-3 rounded-lg shadow-sm flex items-center justify-between">
                <span className="text-gray-800 text-sm font-medium">{getModelName(modelId)}</span>
                <button
                  onClick={() => handleRemoveModel(modelId)}
                  className="text-gray-400 hover:text-red-600 text-lg"
                >
                  ✕
                </button>
              </div>
            ))}

            {/* Add Model Button/Dropdown */}
            <div className="relative">
              {!showModelDropdown ? (
                <button
                  onClick={() => setShowModelDropdown(true)}
                  className="w-full bg-white px-4 py-3 rounded-lg shadow-sm flex items-center justify-center gap-2 hover:bg-gray-50 transition text-sm"
                >
                  <span className="text-lg">+</span>
                  <span className="font-medium">Add a Model</span>
                </button>
              ) : (
                <div className="bg-white p-3 rounded-lg shadow-lg">
                  <div className="flex items-center gap-2 mb-3">
                    <input
                      type="text"
                      value={modelSearchQuery}
                      onChange={(e) => setModelSearchQuery(e.target.value)}
                      placeholder="Search models..."
                      className="flex-1 text-sm outline-none bg-transparent focus:ring-0"
                      autoFocus
                    />
                    <button
                      onClick={() => { setShowModelDropdown(false); setModelSearchQuery(""); }}
                      className="text-gray-400 hover:text-gray-600"
                    >
                      ✕
                    </button>
                  </div>
                  <div className="max-h-48 overflow-y-auto space-y-1">
                    {filteredModels.length > 0 ? (
                      filteredModels.map((model) => (
                        <button
                          key={model.id}
                          onClick={() => handleAddModel(model.id)}
                          disabled={selectedModels.includes(model.id)}
                          className={`w-full text-left px-3 py-2 rounded text-sm hover:bg-gray-100 transition ${
                            selectedModels.includes(model.id) ? "opacity-50 cursor-not-allowed" : ""
                          }`}
                        >
                          {model.name}
                        </button>
                      ))
                    ) : (
                      <div className="text-center text-gray-500 py-3 text-sm">No models found</div>
                    )}
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Configuration Grid */}
          <div className="grid grid-cols-2 gap-3 mb-4">
            <div className="bg-white px-4 py-3 rounded-lg shadow-sm">
              <div className="text-gray-500 text-xs mb-1">Queries (Max. 10)</div>
              <input
                type="text"
                value={numberOfQueries}
                onChange={(e) => {
                  const value = e.target.value;
                  if (value === '' || /^\d+$/.test(value)) {
                    const num = parseInt(value) || 0;
                    if (num <= 10) setNumberOfQueries(num);
                  }
                }}
                className="text-gray-900 text-lg font-semibold w-full bg-gray-100 px-2 py-1 rounded border border-gray-300 focus:border-ecoco-dark focus:bg-white outline-none"
              />
            </div>
            <div className="bg-white px-4 py-3 rounded-lg shadow-sm flex items-center justify-between">
              <label className="flex items-center gap-2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={useOwnData}
                  onChange={(e) => setUseOwnData(e.target.checked)}
                  className="w-5 h-5 cursor-pointer accent-ecoco-dark"
                />
                <span className="text-gray-900 text-sm font-medium">Use your database?</span>
              </label>
              <span className="relative group cursor-help">
                <span className="inline-flex items-center justify-center w-4 h-4 text-xs font-bold text-ecoco-dark border border-ecoco-dark rounded-full">i</span>
                <span className="invisible group-hover:visible absolute right-0 bottom-full mb-2 w-56 p-2 text-xs text-white bg-gray-900 rounded shadow-lg z-10">
                  Edit preset schemas by unchecking, selecting a schema, then checking again.
                </span>
              </span>
            </div>
          </div>

          {/* Schema Selection */}
          {!useOwnData && (
            <div className="bg-white px-4 py-3 rounded-lg shadow-sm mb-4">
              {loadingSchemas ? (
                <div className="text-gray-500 text-sm">Loading schemas...</div>
              ) : (
                <select
                  value={selectedSchema}
                  onChange={(e) => setSelectedSchema(e.target.value)}
                  className="text-gray-900 text-sm font-medium w-full outline-none bg-transparent"
                >
                  <option value="">Select a schema</option>
                  {availableSchemas.map((schema) => (
                    <option key={schema} value={schema}>{schema}</option>
                  ))}
                </select>
              )}
            </div>
          )}

          {/* Question Field */}
          <div className="bg-white px-4 py-3 rounded-lg shadow-sm mb-4">
            <div className="text-gray-600 text-xs mb-2">Question</div>
            <input
              type="text"
              value={question}
              onChange={(e) => setQuestion(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:border-ecoco-dark outline-none"
              placeholder="e.g., Find all movies from 2020"
            />
          </div>

          {/* DDL & Seeding in 2-column layout */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-3 mb-4">
            <div className="bg-white px-4 py-3 rounded-lg shadow-sm">
              <div className="text-gray-600 text-xs mb-2">Data Definition Language</div>
              <CodeEditor
                value={ddl}
                onChange={setDdl}
                disabled={!useOwnData}
                placeholder="Enter your database schema..."
              />
            </div>
            <div className="bg-white px-4 py-3 rounded-lg shadow-sm">
              <div className="text-gray-600 text-xs mb-2">Seeding Data</div>
              <CodeEditor
                value={seedingData}
                onChange={setSeedingData}
                disabled={!useOwnData}
                placeholder="Enter seeding data..."
              />
            </div>
          </div>

          {/* Evaluate Button */}
          <button
            onClick={handleEvaluate}
            disabled={evaluating}
            className="w-full bg-ecoco-dark hover:bg-ecoco-black text-ecoco-light font-bold text-lg py-3 rounded-lg transition disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {evaluating ? "Evaluating..." : "Evaluate"}
          </button>

          {/* Results Section */}
          {results && (
            <div className="mt-8 space-y-4">
              <h2 className="text-xl font-bold text-center mb-4">Results</h2>

              {/* Confidence Results - Only show if more than one model */}
              {results.confidence.models.length > 1 && results.confidence.confidence.all_confidence_scores && results.confidence.confidence.all_confidence_scores.length > 0 && (
                <div className="bg-white px-4 py-3 rounded-lg shadow-sm">
                  <h3 className="text-base font-bold mb-3">Confidence Score Distribution</h3>
                  <div className="space-y-2">
                    {results.confidence.confidence.all_confidence_scores.map((confidenceScore, index) => {
                      const confidence = confidenceScore.confidence_score * 100;
                      const highestConfidence = results.confidence.confidence.all_confidence_scores[0].confidence_score * 100;
                      const isTiedForFirst = Math.abs(confidence - highestConfidence) < 0.01;
                      const numberOfTiedResults = results.confidence.confidence.all_confidence_scores.filter(
                        (score) => Math.abs(score.confidence_score * 100 - highestConfidence) < 0.01
                      ).length;
                      const isActuallyTied = isTiedForFirst && numberOfTiedResults > 1;

                      let bgColor, borderColor, textColor, label;
                      if (isActuallyTied) {
                        bgColor = 'bg-yellow-50'; borderColor = 'border-yellow-300'; textColor = 'text-yellow-800'; label = 'Tied';
                      } else if (index === 0) {
                        bgColor = 'bg-green-50'; borderColor = 'border-green-300'; textColor = 'text-green-800'; label = 'Highest';
                      } else if (confidence >= 70) {
                        bgColor = 'bg-blue-50'; borderColor = 'border-blue-300'; textColor = 'text-blue-800'; label = 'High';
                      } else if (confidence >= 40) {
                        bgColor = 'bg-yellow-50'; borderColor = 'border-yellow-300'; textColor = 'text-yellow-800'; label = 'Medium';
                      } else {
                        bgColor = 'bg-red-50'; borderColor = 'border-red-300'; textColor = 'text-red-800'; label = 'Low';
                      }

                      return (
                        <div key={index} className={`${bgColor} border ${borderColor} rounded p-3`}>
                          <div className="flex items-center justify-between mb-1">
                            <span className={`text-sm font-medium ${textColor}`}>#{index + 1} ({label})</span>
                            <span className={`text-lg font-bold ${textColor}`}>{confidence.toFixed(1)}%</span>
                          </div>
                          <div className="text-xs text-gray-600 mb-2">
                            {confidenceScore.models_contributing}/{results.confidence.confidence.total_models} models
                            <span className="ml-2">
                              {confidenceScore.models_with_result.map((m, i) => (
                                <span key={i} className="inline-block bg-white px-1 py-0.5 rounded text-xs border mr-1">
                                  {getModelName(m.model).split('/').pop()} ({(m.frequency * 100).toFixed(0)}%)
                                </span>
                              ))}
                            </span>
                          </div>
                          <button
                            onClick={() => setSelectedQuery({ model: 'confidence', index, query: '', result: confidenceScore.result })}
                            className={`px-3 py-1 text-xs ${isActuallyTied ? 'bg-yellow-600' : index === 0 ? 'bg-green-600' : 'bg-blue-500'} text-white rounded transition hover:opacity-90`}
                          >
                            View
                          </button>
                        </div>
                      );
                    })}
                  </div>
                </div>
              )}

              {/* Consistency Results for each model */}
              {results.confidence.models.map((modelResult) => {
                const consistencyScore = modelResult.consistency.consistency_vector[0]?.frequency || 0;
                const mostCommonCount = modelResult.consistency.consistency_vector[0]?.count || 0;
                const displayCount = mostCommonCount === 1 ? 0 : mostCommonCount;
                const mostConfidentResult = results.confidence.confidence.most_confident_result?.result;
                const allConfidenceScores = results.confidence.confidence.all_confidence_scores || [];
                const highestConfidence = allConfidenceScores[0]?.confidence_score || 0;
                const tiedResults = allConfidenceScores.filter((score) => Math.abs(score.confidence_score - highestConfidence) < 0.0001);
                const hasTie = tiedResults.length > 1;

                return (
                  <div key={modelResult.model} className="bg-white px-4 py-3 rounded-lg shadow-sm">
                    <div className="flex items-center justify-between mb-2">
                      <h3 className="text-base font-bold">{getModelName(modelResult.model)}</h3>
                      <span className="text-lg font-bold text-gray-900">{(consistencyScore * 100).toFixed(0)}%</span>
                    </div>
                    {modelResult.consistency.total_queries > 1 && (
                      <div className="text-xs text-gray-500 mb-2">
                        {displayCount === 0 || displayCount === 1
                          ? "All queries returned different results"
                          : `${displayCount}/${modelResult.consistency.total_queries} same result`}
                      </div>
                    )}
                    <div className="flex items-center gap-1.5 flex-wrap">
                      {modelResult.results.map((result, index) => {
                        const matchesMostConfident = mostConfidentResult && JSON.stringify(result) === JSON.stringify(mostConfidentResult);
                        const tiedResultIndex = hasTie ? tiedResults.findIndex((tr) => JSON.stringify(result) === JSON.stringify(tr.result)) : -1;
                        const isTiedResult = tiedResultIndex !== -1;

                        let bgColor = "bg-red-500", textColor = "text-white";
                        let content: React.ReactNode = "✗";

                        if (hasTie && isTiedResult) {
                          bgColor = "bg-amber-200"; textColor = "text-amber-800"; content = `#${tiedResultIndex + 1}`;
                        } else if (matchesMostConfident) {
                          bgColor = "bg-green-500"; textColor = "text-white"; content = "✓";
                        }

                        return (
                          <button
                            key={index}
                            onClick={() => setSelectedQuery({ model: modelResult.model, index, query: modelResult.queries[index], result: modelResult.results[index] })}
                            className={`w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold cursor-pointer hover:opacity-80 transition ${bgColor} ${textColor}`}
                            title={`Query ${index + 1}`}
                          >
                            {content}
                          </button>
                        );
                      })}
                    </div>
                  </div>
                );
              })}

              {/* Show Statistics Button */}
              <button
                onClick={handleShowStatistics}
                disabled={generatingStats}
                className="w-full bg-ecoco-dark hover:bg-ecoco-black text-ecoco-light font-bold py-3 rounded-lg transition disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {generatingStats ? "Generating..." : "Show Statistics"}
              </button>
              {statsError && <div className="text-red-600 text-center text-sm">{statsError}</div>}
            </div>
          )}
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-ecoco-dark py-3 px-6">
        <div className="flex gap-6">
          <Link to="/" className="text-sm font-medium text-ecoco-light hover:underline">Home</Link>
          <Link to="/evaluate" className="text-sm font-medium text-ecoco-light hover:underline">Evaluate</Link>
        </div>
      </footer>

      {/* Query Modal */}
      {selectedQuery && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4" onClick={() => setSelectedQuery(null)}>
          <div className="bg-white rounded-lg shadow-xl max-w-3xl w-full max-h-[80vh] overflow-auto" onClick={(e) => e.stopPropagation()}>
            <div className="sticky top-0 bg-white border-b border-gray-200 px-4 py-3 flex items-center justify-between">
              <h3 className="text-base font-bold">
                {selectedQuery.model === 'confidence' ? `Result ${selectedQuery.index + 1}` : `Query ${selectedQuery.index + 1} - ${getModelName(selectedQuery.model)}`}
              </h3>
              <button onClick={() => setSelectedQuery(null)} className="text-gray-400 hover:text-gray-600 text-xl">✕</button>
            </div>
            <div className="p-4 space-y-4">
              {selectedQuery.query && (
                <div>
                  <h4 className="text-sm font-semibold text-gray-700 mb-1">SQL Query</h4>
                  <pre className="bg-gray-50 p-3 rounded border text-xs font-mono whitespace-pre-wrap overflow-x-auto">{selectedQuery.query}</pre>
                </div>
              )}
              <div>
                <h4 className="text-sm font-semibold text-gray-700 mb-1">Results</h4>
                <div className="bg-gray-50 p-3 rounded border overflow-x-auto">
                  {selectedQuery.result && selectedQuery.result.row_count > 0 ? (
                    <table className="min-w-full text-xs">
                      <thead>
                        <tr className="border-b">
                          {selectedQuery.result.columns.map((col: string, i: number) => (
                            <th key={i} className="px-2 py-1 text-left font-semibold text-gray-700">{col}</th>
                          ))}
                        </tr>
                      </thead>
                      <tbody>
                        {selectedQuery.result.rows.map((row: any[], i: number) => (
                          <tr key={i} className="border-b border-gray-200">
                            {row.map((cell: any, j: number) => (
                              <td key={j} className="px-2 py-1 text-gray-600">{cell === null ? 'NULL' : String(cell)}</td>
                            ))}
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  ) : (
                    <div className="text-gray-500 text-center py-2 text-sm">No rows returned</div>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Statistics Modal */}
      {showStatistics && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4" onClick={() => setShowStatistics(false)}>
          <div className="bg-white rounded-lg shadow-xl max-w-5xl w-full max-h-[90vh] overflow-auto" onClick={(e) => e.stopPropagation()}>
            <div className="sticky top-0 bg-white border-b border-gray-200 px-4 py-3 flex items-center justify-between z-10">
              <h3 className="text-lg font-bold">Statistics</h3>
              <div className="flex items-center gap-3">
                {statisticsFigures.length > 0 && (
                  <button
                    onClick={async () => {
                      try {
                        for (const figure of statisticsFigures) {
                          const url = getFigureUrl(figure, statsTimestamp);
                          const response = await fetch(url, { mode: 'cors' });
                          if (!response.ok) throw new Error(`Failed to fetch ${figure}`);
                          const blob = await response.blob();
                          const blobUrl = window.URL.createObjectURL(blob);
                          const link = document.createElement('a');
                          link.href = blobUrl;
                          link.download = figure;
                          link.style.display = 'none';
                          document.body.appendChild(link);
                          link.click();
                          await new Promise(resolve => setTimeout(resolve, 100));
                          document.body.removeChild(link);
                          window.URL.revokeObjectURL(blobUrl);
                        }
                      } catch (err) {
                        console.error('Download failed:', err);
                        alert('Failed to download figures.');
                      }
                    }}
                    className="bg-ecoco-dark hover:bg-ecoco-black text-ecoco-light px-3 py-1.5 rounded text-sm font-medium transition"
                  >
                    Download All
                  </button>
                )}
                <button onClick={() => setShowStatistics(false)} className="text-gray-400 hover:text-gray-600 text-xl">✕</button>
              </div>
            </div>
            <div className="p-4">
              {statisticsFigures.length > 0 ? (
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
                  {statisticsFigures.map((figure, index) => (
                    <div key={index} className="bg-gray-50 rounded p-3 border">
                      <img src={getFigureUrl(figure, statsTimestamp)} alt={`Figure ${index + 1}`} className="w-full h-auto rounded" />
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center text-gray-500 py-6 text-sm">No figures available</div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
