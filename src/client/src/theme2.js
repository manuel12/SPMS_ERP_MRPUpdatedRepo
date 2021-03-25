import { createMuiTheme } from "@material-ui/core/styles";

const theme2 = () =>
  createMuiTheme({
    palette: {
      primary: {
        main: "#0a1582",
      },
    },
    overrides: {
      MuiCssBaseline: {
        "@global": {
          a: {
            textDecoration: "none",
            color: "#0a1582",
          },
        },
      },
    },
    wrapper: {
      width: "100%",
    },
  });

export default theme2;
