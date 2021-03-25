import React, { useState } from "react";
import { IconButton, Menu, MenuItem } from "@material-ui/core";
import { AccountCircle } from "@material-ui/icons";

const UserIcon = () => {
  const [anchorAccount, setAnchorAccount] = useState(null);

  const handleLogOut = (e) => {
    // logout user, set auth to false and redirect to "/"
    setAnchorAccount(null);
  };

  return (
    <>
      <IconButton
        aria-label="account of current user"
        aria-controls="menu-account"
        aria-haspopup="true"
        onClick={(e) => setAnchorAccount(e.currentTarget)}
        color="inherit"
      >
        <AccountCircle />
      </IconButton>
      <Menu
        getContentAnchorEl={null}
        anchorOrigin={{
          vertical: "bottom",
          horizontal: "center",
        }}
        transformOrigin={{
          vertical: "top",
          horizontal: "center",
        }}
        id="menu-account"
        anchorEl={anchorAccount}
        keepMounted
        open={Boolean(anchorAccount)}
        onClose={() => {
          setAnchorAccount(null);
        }}
      >
        <MenuItem onClick={handleLogOut}>Log Out</MenuItem>
      </Menu>
    </>
  );
};

export default UserIcon;
