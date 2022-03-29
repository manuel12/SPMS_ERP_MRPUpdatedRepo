// library imports
import React, { useContext } from "react";
import { Route } from "react-router-dom";
import ProtectedRoute from "./components/ProtectedRoutes";

// material ui imports
import { ThemeProvider } from "@material-ui/core/styles";
import CssBaseline from "@material-ui/core/CssBaseline";
import { Grid } from "@material-ui/core";

// application imports
import theme from "./theme";
import theme2 from "./theme2";
import Header from "./components/Header";
import { AppContext } from "./context/AppContext";
import SideBar from "./components/SideBar.jsx";
import Content from "./components/Content.jsx";
import SignIn from "./components/SignIn";

function App() {
  const { darkMode, isAuthenticated } = useContext(AppContext);

  return (
    <>
      <ThemeProvider theme={theme2()}>
        <CssBaseline />
        
            <Route exact path="/signin" component={SignIn} />
            <ProtectedRoute path="/" user={isAuthenticated}>
              <Grid container direction="column">
                <Grid item>
                  <Header title="SPMS ERP" />
                </Grid>
                <Grid item container wrap="nowrap">
                  <Grid item>
                    <SideBar />
                  </Grid>
                  <Grid item xs={12}>
                    <Content />
                  </Grid>
                </Grid>
              </Grid>
            </ProtectedRoute>
      </ThemeProvider>
    </>
  );
}

export default App;
