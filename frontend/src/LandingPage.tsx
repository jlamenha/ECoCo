export default function LandingPage() {
  return (
    <div className="min-h-screen flex flex-col">
      {/* Hero Section with Gradient */}
      <section className="flex-1 flex flex-col bg-gradient-to-b from-[#acd4fd] to-[#fef3df]">
        {/* Navigation */}
        <nav className="flex gap-6 p-6">
          <button className="text-sm font-medium hover:underline">
            Home
          </button>
          <button className="text-sm font-medium hover:underline">
            Evaluate
          </button>
        </nav>

        {/* Hero Content */}
        <div className="flex-1 flex flex-col items-center justify-center px-6 py-20">
          <h1 className="text-6xl font-serif text-center mb-4">
            Evaluate Large Language Models,
          </h1>
          <h2 className="text-5xl font-bold text-center mb-6">
            for your own database
          </h2>
          <p className="text-lg text-gray-700 mb-8">
            Feed your own tables, test with your own data, evaluate what you want
          </p>
          <button className="bg-black text-white px-6 py-3 rounded hover:bg-gray-800 transition">
            • Explore the Tool
          </button>
        </div>
      </section>

      {/* Preview Image Section */}
      <section className="bg-black py-20 px-6">
        <div className="max-w-5xl mx-auto">
          <div className="bg-white rounded-lg overflow-hidden shadow-2xl">
            <img src="/tool_screenshot.png" alt="Tool Preview" className="w-full h-auto" />
          </div>
        </div>
      </section>

      {/* Bottom Navigation (Yellow Section) */}
      <footer className="bg-yellow-300 py-4 px-6">
        <div className="flex gap-6">
          <button className="text-sm font-medium hover:underline">
            Home
          </button>
          <button className="text-sm font-medium hover:underline">
            Evaluate
          </button>
        </div>
      </footer>
    </div>
  );
}