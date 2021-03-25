import { createMuiTheme } from "@material-ui/core/styles";

const theme = (darkMode) =>
  createMuiTheme({
    palette: {
      type: darkMode ? "dark" : "light",
    },
    overrides: {
      MuiCssBaseline: {
        "@global": {
          a: {
            textDecoration: "none",
            color: darkMode ? "white" : "black",
          },
        },
      },
    },
    wrapper: {
      width: "100%",
    },
  });

export default theme;
