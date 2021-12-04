const express = require("express");
const dbconf = require("../config/config").dbconfig;
const orcldb = require("oracledb");
const router = express.Router();

router.get("/:user_id", async (req, res) => {
  let userId;

  if (req.params.user_id !== undefined) {
    userId = parseInt(req.params.user_id);
  } else {
    throw new Error("Bad request");
  }

  const connection = await orcldb.getConnection(dbconf);

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.GET_PLAYLISTS_FOR_USER(:id, :ret);
     END;`,
    {
      id: userId,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.CURSOR },
    }
  );

  let resultSet = procedureResult.outBinds.ret;
  let resultArray = [];
  let row;
  while ((row = await resultSet.getRow())) {
    resultArray.push({
      id: row[0],
      name: row[1],
      author: row[2],
      genre: row[3],
      source: row[4],
    });
  }

  resultSet.close();
  res.json(resultArray);
});

router.post("/", (req, res) => {});

router.delete("/", (req, res) => {});

router.put("/", (req, res) => {});

router.patch("/", (req, res) => {});

module.exports = router;
