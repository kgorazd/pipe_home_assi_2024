import React from "react";
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { Navigate } from "react-router-dom";

export default () => {
  const [login, setLogin] = React.useState("");
  const [password, setPassword] = React.useState("");

  const handleSubmit = () => {
    // TODO make a proper backend call and process response
    if (login === "user" && password === "123") {
      const backend_response = {
        success: true,
        login: "user",
        api_token: "abc123",
      };
      sessionStorage.setItem("username", backend_response.login);
      sessionStorage.setItem("apiToken", backend_response.api_token);
      window.location.href = "/";
    } else {
      toast.error("🚨 Invalid credentials 🚨");
    }
  };

  return (
    <div className="vw-100 primary-color d-flex align-items-center justify-content-center">
      <div className="jumbotron jumbotron-fluid bg-transparent">
        <div className="container secondary-color">
          <h1 className="display-4">Login</h1>

          <div id="form">
            <label htmlFor="company-name">Username</label>
            <div className="input-group mb-3">
              <input
                type="text"
                className="form-control"
                id="company-name"
                value={login}
                onChange={(e) => setLogin(e.target.value)}
              />
            </div>

            <label htmlFor="industry">Password</label>
            <div className="input-group mb-3">
              <input
                type="text"
                className="form-control"
                id="industry"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
            </div>

            <div className="input-group mb-3">
              <input
                type="submit"
                index="0"
                className="form-control"
                value="Submit"
                onClick={handleSubmit}
              />
            </div>
          </div>
        </div>
      </div>
      <ToastContainer theme="dark" position="top-center" autoClose="1500" />
    </div>
  );
};
