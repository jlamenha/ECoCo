import { BrowserRouter, Routes, Route } from "react-router-dom";
import Home from "./pages/Home";
import Evaluate from "./pages/Evaluate";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/evaluate" element={<Evaluate />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App
