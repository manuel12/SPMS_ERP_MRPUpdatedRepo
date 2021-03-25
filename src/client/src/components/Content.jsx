import React, { useState, useEffect } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Switch, Route } from "react-router-dom";
import { useTheme } from "@material-ui/core/styles";

import {
  Typography,
  Toolbar,
  Tab,
  Box,
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  IconButton,
} from "@material-ui/core";
import { makeStyles } from "@material-ui/core/styles";
import { TabPanel, TabContext, TabList } from "@material-ui/lab";

import { CloseRounded } from "@material-ui/icons";

// application imports
import EmployeeCreate from "./EmployeeCreate";
import EmployeeList from "./EmployeeList";
import EmployeeDetail from "./EmployeeDetail";
// import theme from "../theme";

const useStyles = makeStyles((theme) => ({
  tabs: {
    backgroundColor: theme.palette.background.paper,
    padding: "0",
    borderRight: "1px solid",
    borderBottom: "1px solid",
  },
  selectedTab: {
    backgroundColor: theme.palette.background.paper,
    padding: "0",
    borderRight: "1px solid",
    borderBottom: "0",
  },

  tabHeader: {
    width: "100%",
    display: "flex",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    padding: "0 10px",
  },
  tabLabel: {
    // padding: "0 10px",
    // flexGrow: 1,
  },
  closeIconContainer: {
    padding: "0",
  },
  closeIcon: {
    fontSize: "16px",
  },
  tabPanel: {
    backgroundColor: theme.palette.background.paper,
    padding: "0",
  },
}));

const Content = () => {
  const classes = useStyles();
  const theme = useTheme();
  const [tabs, setTabs] = useState([]);
  const [selectedTab, setSelectedTab] = useState("1");

  const newTab = {
    icon: "users",
    label: "Employees",
    dataURL: "/employees",
    ID: "1",
  };
  const newTab2 = {
    icon: "cogs",
    label: "Parts",
    dataURL: "/parts",
    ID: "2",
  };

  const addTab = (tab) => setTabs((tabs) => [...tabs, tab]);

  const removeTab = (e, tabID) => {
    e.stopPropagation();
    setTabs(tabs.filter((tab) => tab.ID !== tabID));
  };

  useEffect(() => {
    addTab(newTab);
    addTab(newTab2);
  }, []);

  console.log("TABS:", tabs);
  return (
    <main>
      <Toolbar variant="dense" />
      <TabContext value={selectedTab}>
        <TabList
          onChange={(e, tabSelected) => {
            setSelectedTab(tabSelected);
          }}
          // textColor="black"
          indicatorColor={theme.palette.background.paper}
        >
          {tabs.map((tab, index) => (
            <Tab
              classes={{ wrapper: classes.tabHeader }}
              icon={
                <>
                  <FontAwesomeIcon icon={tab.icon} />
                  <Typography variant="body2" className={classes.tabLabel}>
                    {tab.label}
                  </Typography>
                  <IconButton
                    className={classes.closeIconContainer}
                    onClick={(e) => removeTab(e, tab.ID)}
                    color="secondary"
                  >
                    <CloseRounded className={classes.closeIcon} />
                  </IconButton>
                </>
              }
              value={tab.ID}
              className={
                selectedTab === tab.ID ? classes.selectedTab : classes.tabs
              }
            />
          ))}
        </TabList>
        <TabPanel value="1" className={classes.tabPanel}>
          <Switch>
            <Route path="/employees/create">
              <EmployeeCreate />
            </Route>
            <Route path="/employees/:id">
              <EmployeeDetail />
            </Route>

            <Route path="/employees">
              <EmployeeList />
            </Route>
          </Switch>
        </TabPanel>
      </TabContext>
    </main>
  );
};

export default Content;
