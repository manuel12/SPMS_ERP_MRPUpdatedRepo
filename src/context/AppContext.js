import React from 'react';

const AppContext = React.createContext();

class AppContextProvider extends React.Component {
  state = {};

  render() {
    return (
      <AppContext.Provider value={this.state}>
        {this.props.children}
      </AppContext.Provider>
    );
  }
}

export default AppContext;
