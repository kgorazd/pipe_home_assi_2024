import React from 'react';
import { Navigate } from 'react-router-dom';

export default () => {
  sessionStorage.removeItem("username");
  sessionStorage.removeItem("apiToken");
  return <Navigate replace to="/login" />
};
