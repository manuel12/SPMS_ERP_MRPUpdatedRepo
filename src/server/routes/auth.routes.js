const express = require("express");
const router = express.Router();

const authJwt = require("../middleware/authJWT");
const verifySignUp = require("../middleware/verifySignUp");
const controller = require("../controllers/auth.controller");

// routes
router.post(
  "/signup",
  [
    authJwt.verifyToken,
    authJwt.isAdmin,
    verifySignUp.checkDuplicateUsernameOrEmail,
    verifySignUp.checkRolesExist,
  ],
  controller.signup
);

router.post("/signin", controller.signin);

module.exports = router;
