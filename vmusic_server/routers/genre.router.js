const express = require("express");
const router = express.Router();

router.get("/", (req, res) => {
  res.send(JSON.stringify({ text: "Hello, World!!!" }));
});

router.post("/", (req, res) => {});

router.delete("/", (req, res) => {});

router.put("/", (req, res) => {});

router.patch("/", (req, res) => {});

module.exports = router;
