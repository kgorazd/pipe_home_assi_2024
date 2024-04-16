import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from "../components/Home";
import LoginPage from "../components/LoginPage";
import LogoutPage from "../components/LogoutPage";

export default (
  <Router>
    <Routes>
      <Route path="/" element={ sessionStorage.getItem("apiToken") == null ? <LoginPage/> : <Home /> } />
      <Route path="/login" element={<LoginPage />} />
      <Route path="/logout" element={<LogoutPage />} />
    </Routes>
  </Router>
);
