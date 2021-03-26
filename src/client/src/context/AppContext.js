import React, { useState, createContext } from "react";

export const AppContext = createContext();

export const AppContextProvider = (props) => {
  const [darkMode, setDarkMode] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  return (
    <AppContext.Provider
      value={{ darkMode, setDarkMode, isAuthenticated, setIsAuthenticated }}
    >
      {props.children}
    </AppContext.Provider>
  );
};
